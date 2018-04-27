//
//  Utility.swift
//  TwitterDemo
//
//  Created by Ankit Teotia on 14/9/18.
//  Copyright © 2018 Ankit Teotia. All rights reserved.
//

import UIKit

typealias OnPositive = () -> Void
typealias OnNegative = () -> Void

class Utility: NSObject {
    
    static func alertAction(vc: UIViewController, title: String?, message: String, okBtn: String, cancelBtn: String, positive:@escaping OnPositive, negative:@escaping OnNegative) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okButton = UIAlertAction(title: okBtn, style: UIAlertActionStyle.default) { (alert) in
            positive();
        }
        let cancelButton = UIAlertAction(title: cancelBtn, style: UIAlertActionStyle.default) { (alert) in
            negative();
        }
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func alert(vc: UIViewController, title: String?, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(okButton)
        
        vc.present(alert, animated: true, completion: nil)
    }

    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    static func storyboard() -> UIStoryboard {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }

}

