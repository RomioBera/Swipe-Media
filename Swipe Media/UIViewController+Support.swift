//
//  UIViewController+Support.swift
//  Denwa Sensei
//
//  Created by Basir Alam on 13/06/17.
//  Copyright © 2017 Basir. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: for Email validation
   func isValidEmail(emailStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: emailStr)

    
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._]+@[A-Za-z0-9]+\\.[A-Za-z]{2,10}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailStr)
    
    }
    
    //MARK: for aler message
    func showAlertMessage(alertTitle: String, alertMsg : String)
    {
        let alertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Check a key is present in UserDefaults
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
}

//MARK: Set Hex color
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: Make circle of image
extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

//MARK: Know device size
extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .unknown
        }
    }
}
