//
//  APIClient.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 11/29/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

//STATUS API CLIENT

import Foundation
class APIClient {
    var apiVersion: String!
    var baseURL: String = "http://104.197.172.164:12000"
    var viewController: StatusViewController!
    
    required init (parent: StatusViewController!) {
        viewController = parent
    }

    func openStatus() {
        // GET open status
        getData(APIService.DOOR)
    }
    
    func lockStatus() {
        getData(APIService.STATUS)
    }
    
    func postData (service: APIService, id: String!=nil, urlSuffix: NSArray!=nil, params: [String:String]!=[:]) {
        let blockSelf = self
        let logger: UILogger = viewController.logger
        self.apiRequest(
            service,
            method: APIMethod.POST,
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
    
    func processPOSTData (service: APIService, id: String!, urlSuffix: NSArray!, params: [String:String]!=[:], responseJson: NSDictionary!) {
        //function POST data
    }
    
    
    func getData (service: APIService, id: String!=nil, urlSuffix: NSArray!=nil, params: [String:String]!=[:]) {
        let blockSelf = self
        let logger: UILogger = viewController.logger
        self.apiRequest(
            service,
            method: APIMethod.GET,
            /*id: id,*/
            urlSuffix: urlSuffix,
            inputData: params,
            callback: { (responseJson: NSDictionary!, responseError: NSError!) -> Void in
                if (responseError != nil) {
                    logger.logEvent(responseError!.description)
                    // Handle error here
                }
                else {
                    blockSelf.processGETData(service, id: id, urlSuffix: urlSuffix, params: params, responseJson: responseJson)
                }
        })
    }
    
    func processGETData (service: APIService, id: String!, urlSuffix: NSArray!, params: [String:String]!=[:], responseJson: NSDictionary!) {
        // function GET data
    }
    
    func apiRequest (
        service: APIService,
        method: APIMethod,
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
            //make request
            let x = "(0,)"
            let y = "(1,)"
            let doorStatusURL = "http://104.197.172.164:12000/getOpenStatus"
            let lockStatusURL = "http://104.197.172.164:12000/getLockedStatus"
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

                    if rData == x && serviceURL == doorStatusURL {
                        logger.logEvent("The Door is Currently Closed." )
                        print("RESPONSE RAW: \(rData)")
                    }
                    else if rData == y && serviceURL == doorStatusURL{
                        logger.logEvent("The Door is Currently Opened.")
                        print("RESPONSE RAW: \(rData)")
                    }
                    else if rData == x && serviceURL == lockStatusURL {
                        logger.logEvent("The Door is Currently Unlocked." )
                        print("RESPONSE RAW: \(rData)")
                    }
                    else if rData == y && serviceURL == lockStatusURL{
                        logger.logEvent("The Door is Currently Locked.")
                        print("RESPONSE RAW: \(rData)")
                    }
                    else {
                        logger.logEvent("RESPONSE RAW: " + (rData.isEmpty ? "No Data" : rData) + serviceURL )
                        print("RESPONSE RAW: \(rData)")
                        }
                    }
                    
                    //logger.logEvent("RESPONSE RAW: " + (rData.isEmpty ? "No Data" : rData) )
                    //print("RESPONSE RAW: \(rData)")
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
            params.append( [ key.escapeUrl(), value.escapeUrl()].joinWithSeparator("=" ))
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
    func escapeUrl() -> String {
        let source: NSString = NSString(string: self)
        let chars = "abcdefghijklmnopqrstuvwxyz"
        let okChars = chars + chars.uppercaseString + "0123456789.~_-"
        let customAllowedSet = NSCharacterSet(charactersInString: okChars)
        return source.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
    }
}

enum APIService {
    case DOOR, STATUS
    func toString() -> String {
        var service: String!
        switch self {
            
        case .DOOR:
            service = "getOpenStatus"
            
        case .STATUS:
            service = "getLockedStatus"
            
        }
        return service
    }
}

enum APIMethod {
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
