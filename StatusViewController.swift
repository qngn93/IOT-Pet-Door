//
//  StatusViewController.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 12/1/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    

    @IBOutlet var doorStatusButton: UIButton!
    @IBOutlet var lockStatusButton: UIButton!
    @IBOutlet var textArea: UITextView!
    
    @IBOutlet var clearButton: UIButton!
    var api: APIClient!
    var logger: UILogger!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIClient(parent: self)
        logger = UILogger(out: textArea)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unclickButton() {
        doorStatusButton.setTitle("Door Status", forState: UIControlState.Normal)
    }
    
    @IBAction func unclickButton2() {
        lockStatusButton.setTitle("Lock Status", forState: UIControlState.Normal)
    }
    
    @IBAction func clickedButton() {
        logger.logEvent("Receiving Door Status...")
        api.openStatus()
        doorStatusButton.setTitle("Door Status", forState: UIControlState.Normal)
    }
    
    @IBAction func clickedButton2() {
        logger.logEvent("Receiving Lock Status...")
        api.lockStatus()
        lockStatusButton.setTitle("Lock Status", forState: UIControlState.Normal)
    }
    
    
    @IBAction func clearFunc() {
        logger.set()
    }
}