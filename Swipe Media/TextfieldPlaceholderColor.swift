//
//  TextfieldPlaceholderColor.swift
//  Kiti
//
//  Created by Amit Kumar Poreli on 05/04/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func setPlaceholderColer(textField : UITextField,str : String)
    {
//        textField.attributedPlaceholder = NSAttributedString(string: str,
//                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)])
        
        
       // UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        textField.attributedPlaceholder = NSAttributedString(string:str,
        attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
       // textField.font = UIFont.boldSystemFont(ofSize: 18)
       // textField.font = UIFont(name: "Lato-Bold.ttf", size: 20)
    }
    
    
    
}
