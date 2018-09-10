//
//  RegistrationController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 07/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class RegistrationController: UIViewController {

    @IBOutlet var userNameTxt: UITextField!
    @IBOutlet var emailIdTxt: UITextField!
    @IBOutlet var phoneNoTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmPasswordTxt: UITextField!
    @IBOutlet var createAccountView: UIView!
    @IBOutlet var loginView: UIView!
    
    var ref: DatabaseReference!
    var dummyTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userNameTxt.delegate = self
        self.emailIdTxt.delegate = self
        self.phoneNoTxt.delegate = self
        self.passwordTxt.delegate = self
        self.confirmPasswordTxt.delegate = self
        
        // For Registration View
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        createAccountView.addGestureRecognizer(tap)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        self.view.addGestureRecognizer(tap1)
        
        //For Login View
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        self.loginView.addGestureRecognizer(tap2)
        
        setPlaceholder()
        addDoneButtonOnKeyboard()
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 163, width: 106, height: 53))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        done.tintColor = UIColor.white
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        
        self.phoneNoTxt.inputAccessoryView = doneToolbar
      
        
    }
    
    @objc func doneButtonAction()
    {
       self.passwordTxt.becomeFirstResponder()
    }
    
    
    //Registration Button Action :
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if let email = emailIdTxt.text , let password = passwordTxt.text {
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            Auth.auth().createUser(withEmail: email, password: password,completion:  { (user, error) in
                
                if let firebaseError = error
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("Unsucessful")
                    print(firebaseError.localizedDescription)
                    
                    self.showAlertMessage(alertTitle: "Error", alertMsg: String(firebaseError.localizedDescription))
                    
                    return
                }
                

                self.createUserDatabase()
                
                let alertController = UIAlertController(title: "Congratulation", message: "You sucessfully register for this app..", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    self.navigationController?.popViewController(animated: true)
               // MBProgressHUD.hide(for: self.view, animated: true)
                }
               
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            })
            
            
        }
        
    }
    
    // Keyboard will resign response after clicling view
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        
        
        self.dummyTextField.resignFirstResponder()
        
        
    }
    
    // Login btn Action
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.popViewController(animated: true)
      
    }
        
    
    func setPlaceholder()
    {
      
        setPlaceholderColer(textField: userNameTxt,str: "User Name")
        setPlaceholderColer(textField: emailIdTxt,str: "Email")
        setPlaceholderColer(textField: phoneNoTxt,str: "Phone No")
        setPlaceholderColer(textField: passwordTxt,str: "Password")
        setPlaceholderColer(textField: confirmPasswordTxt,str: "Confirm Password")
        
    }
    
    func userData()
    {
        let password = self.passwordTxt.text
        let userName = self.emailIdTxt.text
        
        let userdata : [String : Any] = ["password" : password! ,"username" : userName!]
        
        ref = Database.database().reference()
        
        ref.child("Normal User Data ").childByAutoId().setValue(userdata)
        
    }
    func createUserDatabase()
    {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let feed = [
            "userId": uid!,
            "profilePic" : " ",
            "userName"      : self.userNameTxt.text!,
            "loginType"     : "Other",
            "followersCount"     : 0,
            "followingCount"     : 0,
            "key"            : " "
            ] as [String :Any]
        
        ref.child("Users").child(uid!).updateChildValues(feed)
        
        
    }
    
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
     
    }
}


extension RegistrationController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == userNameTxt)
        {
            emailIdTxt.becomeFirstResponder()
        }
        else if (textField == emailIdTxt)
        {
            phoneNoTxt.becomeFirstResponder()
        }
        else if (textField == passwordTxt)
        {
            confirmPasswordTxt.becomeFirstResponder()
        }
        else
        {
            confirmPasswordTxt.resignFirstResponder()
        }
        return true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.dummyTextField = textField
        return true
    }
    
    
}

