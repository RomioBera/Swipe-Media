//
//  LoginController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 07/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import Parse
import MBProgressHUD

class LoginController: UIViewController,FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    

     var ref: DatabaseReference!
    var dict : [String : AnyObject]!
    var login = " "
    var dummmytextField = UITextField()
    var isClick  = false
    var isNewUser = true
    @IBOutlet var terms_ConditionView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var gmailView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var forgotView: UIView!
    @IBOutlet var userNameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var checkBtn: UIButton!
    
    
    private let dataUrl = "https://swipe-media.firebaseio.com/"
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        facebookView.addGestureRecognizer(tap)
 
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        gmailView.addGestureRecognizer(tap2)
        
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(_:)))
        twitterView.addGestureRecognizer(tap3)
        
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap4(_:)))
        forgotView.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap5(_:)))
        view.addGestureRecognizer(tap5)
        
            setPlaceholderColer(textField: userNameTxt,str: "Email")
            setPlaceholderColer(textField: passwordTxt,str: "Password")
            userNameTxt.delegate = self
            passwordTxt.delegate = self
        
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
         self.navigationController?.isNavigationBarHidden = true
        
        if UserDefaults.standard.object(forKey: "isSelected") == nil
        {
            
            self.terms_ConditionView.frame =  CGRect(x: CGFloat(0), y: (64), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
             self.view.addSubview(self.terms_ConditionView)
        }
        else
        {
           
            if Auth.auth().currentUser != nil
            {
                pushController()
            }
        }
       
        
    }
    
    // Mark: Facebook Btn Action
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
       
        login = "facebook"
        SingleToneClass.shared.loginType   = "facebook"
         UserDefaults.standard.set("facebook", forKey: "loginType")
        loginButtonClicked()
        // loginButton.delegate = self
        
      
    }
    
    
    
    
  //  https://fire-base-test-53b79.firebaseapp.com/__/auth/handler
    
    
   
    // Mark: Gmail Btn Action
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        
        login = "gmail"
        SingleToneClass.shared.loginType   = "gmail"
         UserDefaults.standard.set("gmail", forKey: "loginType")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    // Mark: Twitter Btn Action
    @objc func handleTap3(_ sender: UITapGestureRecognizer) {
        
    
        
        showAlertMessage(alertTitle: "Alert", alertMsg: "This part is under development...")
        
    }
    
    
    // Mark: Forgot Btn Action
    @objc func handleTap4(_ sender: UITapGestureRecognizer) {
       
          let alert = UIAlertController(title: "Reset your password",
                                      message: nil,
                                      preferredStyle: .alert)
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            let emailId = textField.text!
            
            
            Auth.auth().fetchProviders(forEmail: emailId, completion: {
                (providers, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                    
                else if let providers = providers {
                    print(providers)
                    
                    
                    Auth.auth().sendPasswordReset(withEmail: emailId) { error in
                        
                        if (error != nil)
                        {
                            print(error)
                        }
                        else
                        {
                            print("=====")
                        }
                        
                    }
                }
                    
                else
                {
                    print("++++++++")
                    
                    self.showAlertMessage(alertTitle: "Alert", alertMsg: "This email id does not exits....")
                    
                }
                
            })
         
            
        })
       
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter your email id.."
            textField.clearButtonMode = .whileEditing
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
 
        
     

        
    }
    
    
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if isClick == false
        {
            isClick = true
            checkBtn.setBackgroundImage(UIImage(named: "chkbox.png"), for: .normal)
            
        }
        else
        {
            isClick = false
            checkBtn.setBackgroundImage(UIImage(named: "unchk.png"), for: .normal)
        }
        
        
    }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
        
        UserDefaults.standard.set("set", forKey: "isSelected")
        
        terms_ConditionView.removeFromSuperview()
    }
    
    @objc func handleTap5(_ sender: UITapGestureRecognizer) {
        
        dummmytextField.resignFirstResponder()
        
    }
   
    
    @objc func loginButtonClicked() {
        
     //   let myRootRef = Database(url : dataUrl)
        
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.email,.publicProfile,], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
       
        
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            
            print("ssssss")
           // self.pushController()
    }
    
    }
    
    func getFBUserData(){
     
        
        
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        
      
        
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        print(accessToken.tokenString)
        print(credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print(error)
                print(error.localizedDescription)
                print("dfgdfgdf")
                return ;
            }
            
            print("ssssss")
           // self.pushController()
            self.createUserDatabase()
        }
        
        
       
    }
    
    
    func createUserDatabase()
    {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        //.queryOrderedByKey()
        ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            if snapshot.childrenCount == 0
            {
                let feed = [
                    "userId": uid!,
                    "profilePic" : " ",
                    "userName"      : Auth.auth().currentUser?.displayName ?? self.userNameTxt.text!,
                    "loginType"     : self.login,
                    "followersCount"     : 0,
                    "followingCount"     : 0,
                    "key"            : " "
                    ] as [String :Any]
                
                ref.child("Users").child(uid!).updateChildValues(feed)
                
                self.isNewUser = false
            }
            else
            {
                self.isNewUser = false
            }
            
            self.pushController()
            //print(snapshot)
        })
        
        
        
    }
    
    
    
    func pushController()
    {
      //  let userID = Auth.auth().currentUser!.uid
//        print(userID)
//
//        ref = Database.database().reference()
//
//       // ref.child("User Data").childByAutoId().setValue(userdata)
//        self.ref?.child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
////            print(snapshot.value)
////
////            let userEmail = (snapshot.value as! NSDictionary)["addedByUser"] as! String
////            print(userEmail)
//            let userInfo = Auth.auth().currentUser?.providerData[0].displayName
//            print(userInfo)
//
//        })
        
        
//        let uid = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference()
//        let key  =  ref.childByAutoId().key
//        let feed = [
//            "userId": uid,
//            "profilePic" : " ",
//            "userName"      : Auth.auth().currentUser?.displayName ?? " ",
//            "key"           : key
//            ] as [String :Any]
//
//
//        ref.child("Users").child(uid).setValue(feed)
//
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        
       //  homeVC.loginType = login
        
        self.navigationController?.pushViewController(homeVC, animated: false)
        
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController //change this to your class name
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        let regVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationController") as! RegistrationController
        
        
        self.navigationController?.pushViewController(regVC, animated: false)
        
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        login = "other"
         UserDefaults.standard.set("emailpassword", forKey: "loginType")
        
        if let email = userNameTxt.text , let password = passwordTxt.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {
                
                (user,error) in
                
                if let firebaseError = error
                {
                    print(firebaseError.localizedDescription)
                    
                    self.showAlertMessage(alertTitle: "Error", alertMsg: String(firebaseError.localizedDescription))
                    return
                }
                print("goof")
                
              //  self.pushController()
                self.createUserDatabase()
                
            })
            
            
        }
        
        
        
        
        
        
        
    }
    
    }


extension LoginController : GIDSignInUIDelegate, GIDSignInDelegate
{
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
        
        
    }
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        
        
        print("dfgdsgfds")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        
        if  error == nil {
            
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            // ...
            
//            name = user.profile.name
//            id = String(user.userID )
//            emailId = user.profile.email
//
//            print(name)
//            print(emailId)
//            print(id)
            
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    return
                }
                // User is signed in
                // ...
                
                print("GPLUS")
             //  self.pushController()
               self.createUserDatabase()
            }
            
        }
        else {
            
            print("\(error.localizedDescription)")
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
}

extension LoginController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTxt
        {
            passwordTxt.becomeFirstResponder()
            
        }
        else {
            passwordTxt.resignFirstResponder()
        }
        return true
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.dummmytextField = textField
        return true
    }
    
}

