//
//  OpenAPIClient.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 12/1/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

import Foundation
class OpenAPIClient {
    var apiVersion: String!
    var baseURL: String = "http://104.197.172.164:12000"
    var viewController: OpenViewController!
    
    required init (parent: OpenViewController!) {
        viewController = parent
    }
    
    func open() {
        // POST /OPEN
        postData(OpenAPIService.OPEN)
    }
    
    func close() {
        // POST /CLOSE
        postData(OpenAPIService.CLOSE)
    }
    
    func postData (service: OpenAPIService, id: String!=nil, urlSuffix: NSArray!=nil, params: [String:String]!=[:]) {
        let blockSelf = self
        let logger: UILogger = viewController.logger
        self.apiRequest(
            service,
            method: OpenAPIMethod.POST,
            /*id: id,*/
            urlSuffix: urlSuffix,
            inputData: params,
            callback: { (responseJson: NSDictionary!, responseError: NSError!) -> Void in
                if (responseError != nil) {
                    logger.logEvent(responseError!.description)
                    // Handle here the error response in some way
                }
                else {
                    blockSelf.processPOSTData(service, id: id, urlSuffix: urlSuffix, params: params, responseJson: responseJson)
                }
        })
    }
    
    func processPOSTData (service: OpenAPIService, id: String!, urlSuffix: NSArray!, params: [String:String]!=[:], responseJson: NSDictionary!) {
    }
    
    
    func getData (service: OpenAPIService, id: String!=nil, urlSuffix: NSArray!=nil, params: [String:String]!=[:]) {
        let blockSelf = self
        let logger: UILogger = viewController.logger
        self.apiRequest(
            service,
            method: OpenAPIMethod.GET,
            /*id: id,*/
            urlSuffix: urlSuffix,
            inputData: params,
            callback: { (responseJson: NSDictionary!, responseError: NSError!) -> Void in
                if (responseError != nil) {
                    logger.logEvent(responseError!.description)
                    // Handle here the error response in some way
                }
                else {
                    blockSelf.processGETData(service, id: id, urlSuffix: urlSuffix, params: params, responseJson: responseJson)
                }
        })
    }
    
    func processGETData (service: OpenAPIService, id: String!, urlSuffix: NSArray!, params: [String:String]!=[:], responseJson: NSDictionary!) {
        //function GET data
    }
    
    func apiRequest (
        service: OpenAPIService,
        method: OpenAPIMethod,
        /*id: String!,*/
        urlSuffix: NSArray!,
        inputData: [String:String]!,
        callback: (responseJson: NSDictionary!, responseError: NSError!) -> Void ) {
            // Compose the base URL
            var serviceURL = baseURL + "/"
            if apiVersion != nil {
                serviceURL += apiVersion + "/"
            }
            serviceURL += service.toString()
            
            /* if id != nil && !id.isEmpty {
            serviceURL += "/" + id
            }*/
            let request = NSMutableURLRequest()
            request.HTTPMethod = method.toString()
            // The urlSuffix contains an array of strings that is used to compose URL
            if urlSuffix?.count > 0 {
                serviceURL += "/" + urlSuffix.componentsJoinedByString("/")
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.URL = NSURL(string: serviceURL)
            
            if !inputData.isEmpty {
                serviceURL += "?" + asURLString(inputData)
                request.URL = NSURL(string: serviceURL)
            }
            //Make a request
            let logger: UILogger = viewController.logger
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data : NSData?, urlResponse : NSURLResponse?, error: NSError?) -> Void in
                //the request returned with a response or possibly an error
                //logger.logEvent("URL: " + serviceURL)
                var error: NSError?
                var jsonResult: NSDictionary?
                if urlResponse != nil {
                    let rData: String = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                    if data != nil {
                        do {
                            try jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        } catch {
                            //print("json error: \(error)")
                        }
                    }
                    logger.logEvent((rData.isEmpty ? "No Data" : rData))
                    print("RESPONSE RAW: \(rData)")
                }
                else {
                    error = NSError(domain: "response", code: -1, userInfo: ["reason":"blank response"])
                }
                callback(responseJson: jsonResult, responseError: error)
            }
            task.resume()
    }
    
    func asURLString (inputData: [String:String]!=[:]) -> String {
        var params: [String] = []
        for (key, value) in inputData {
            params.append( [ key.openEscapeUrl(), value.openEscapeUrl()].joinWithSeparator("=" ))
        }
        params = params.sort{ $0 < $1 }
        return params.joinWithSeparator("&")
    }
    
    
    func prettyJSON (json: NSDictionary!) -> String! {
        var pretty: String!
        if json != nil && NSJSONSerialization.isValidJSONObject(json!) {
            if let data = try? NSJSONSerialization.dataWithJSONObject(json!, options: NSJSONWritingOptions.PrettyPrinted) {
                pretty = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            }
        }
        return pretty
    }
    
}

extension String {
    func openEscapeUrl() -> String {
        let source: NSString = NSString(string: self)
        let chars = "abcdefghijklmnopqrstuvwxyz"
        let okChars = chars + chars.uppercaseString + "0123456789.~_-"
        let customAllowedSet = NSCharacterSet(charactersInString: okChars)
        return source.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
    }
}

enum OpenAPIService {
    case OPEN, CLOSE
    func toString() -> String {
        var service: String!
        switch self {
            
        case .OPEN:
            service = "setOpenStatus=1"
            
        case .CLOSE:
            service = "setOpenStatus=0"
            
        }
        return service
    }
}

enum OpenAPIMethod {
    case GET, POST
    func toString() -> String {
        var method: String!
        switch self {
        case .GET:
            method = "GET"
        case .POST:
            method = "POST"
        }
        return method
    }
}
