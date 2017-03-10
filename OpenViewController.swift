//
//  OpenViewController.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 12/1/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {
    
    
    @IBOutlet var openButton: UIButton!
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var textArea: UITextView!
    
    @IBOutlet var clearButton: UIButton!
    
    var api: OpenAPIClient!
    var logger: UILogger!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = OpenAPIClient(parent: self)
        logger = UILogger(out: textArea)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unclickButton() {
        openButton.setTitle("Open Door", forState: UIControlState.Normal)
    }
    
    @IBAction func unclickButton2() {
        closeButton.setTitle("Close Door", forState: UIControlState.Normal)
    }
    
    @IBAction func clickedButton() {
        logger.logEvent("Opening Door...")
        api.open()
        openButton.setTitle("Open Door", forState: UIControlState.Normal)
    }
    
    @IBAction func clickedButton2() {
        logger.logEvent("Closing Door...")
        api.close()
        closeButton.setTitle("CLose Door", forState: UIControlState.Normal)
    }
    
    
    @IBAction func clearFunc() {
        logger.set()
    }
}