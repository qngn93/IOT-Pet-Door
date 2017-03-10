//
//  LockViewController.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 12/1/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

import UIKit

class LockViewController: UIViewController {
    
    

    @IBOutlet var lockButton: UIButton!

    @IBOutlet var unlockButton: UIButton!
    
    @IBOutlet var textArea: UITextView!
    
    @IBOutlet var clearButton: UIButton!
    
    
    var api: LockAPIClient!
    var logger: UILogger!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = LockAPIClient(parent: self)
        logger = UILogger(out: textArea)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unclickButton() {
        lockButton.setTitle("Lock Door", forState: UIControlState.Normal)
    }
    
    @IBAction func unclickButton2() {
        unlockButton.setTitle("Unlock Door", forState: UIControlState.Normal)
    }
    
    @IBAction func clickedButton() {
        logger.logEvent("Locking Door...")
        api.lock()
        lockButton.setTitle("Lock Door", forState: UIControlState.Normal)
    }

    
    @IBAction func clickedButton2() {
        logger.logEvent("Unlocking Door...")
        api.unlock()
        unlockButton.setTitle("Unlock Door", forState: UIControlState.Normal)
    }

    
    @IBAction func clearFunc() {
        logger.set()
    }
}