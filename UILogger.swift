//
//  UILogger.swift
//  ConvenientPetDoor
//
//  Created by Quoc Nguyen on 11/29/16.
//  Copyright © 2016 Quoc Nguyen. All rights reserved.
//

import Foundation
import UIKit

class UILogger {
    var textArea : UITextView!
    
    required init(out: UITextView) {
        dispatch_async(dispatch_get_main_queue()) {
            self.textArea = out
        };
        self.set()
    }
    
    func set(text: String?="") {
        dispatch_async(dispatch_get_main_queue()) {
            self.textArea!.text = text
        };
    }
    
    func logEvent(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.textArea!.text = self.textArea!.text.stringByAppendingString("~" + message + "\n\n")
        };
    }
}