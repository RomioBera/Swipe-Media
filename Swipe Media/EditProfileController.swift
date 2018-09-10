//
//  EditProfileController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 04/09/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
import SDWebImage

class EditProfileController: UIViewController {
 
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var userNameTxt: UITextField!
    
     var imagePicker = UIImagePickerController()
     var imageURL: NSURL?
     var isUserNameChanged = false
    var userName = " "
   var imgUrl = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backBtn()
        
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
        self.profileImg.clipsToBounds = true
        self.userNameTxt.text = userName
        self.profileImg.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage(named: "User"))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func addPicBtnAction(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @IBAction func submiteBtnAction(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        
        
        if (self.imageURL == nil)
        {
            let refnew = Database.database().reference().child("Users").child(uid)
            
            refnew.observe(.value, with:{ (snapshot) in
                
                let feed = [
                    
                    "userName"   : self.userNameTxt.text
                    
                ]
                
                refnew.updateChildValues(feed)
                
            })
        }
        else
        {
            // let key  = ref.child("userProfileData").childByAutoId().key
            let refnew = Database.database().reference().child("Users").child(uid)
            
            refnew.observe(.value, with:{ (snapshot) in
                
                let feed = [
                    
                    "profilePic" : self.imageURL?.absoluteString as Any,
                    "userName"   : self.userNameTxt.text
                    
                ]
                
                refnew.updateChildValues(feed)
                
            })
        }
        
    }
    
    
    
    
}



extension EditProfileController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @objc  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        
        if let image = info[UIImagePickerControllerEditedImage ] as? UIImage
        {
            //                print(info)
            //                print(info[si])
            
            let heightInPoints = image.size.height
            let heightInPixels = heightInPoints * image.scale
            
            let widthInPoints = image.size.width
            let widthInPixels = widthInPoints * image.scale
            
            print(heightInPoints)
            print(widthInPoints)
            
            print(heightInPixels)
            print(widthInPixels)
            
            
            self.profileImg.image = image
        }
        myImageUploadRequest()
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func myImageUploadRequest()
    {
        
        let imageData = UIImageJPEGRepresentation(self.profileImg.image!, 0.9)
        print(imageData!)
        
        if(imageData==nil)  {
            
            
            
            showAlertMessage(alertTitle: "Error", alertMsg: "Something going wrong try again..")
            return
            
        }
        // let ref = Database.database().reference().child("comments").queryOrdered(byChild: "postID").queryEqual(toValue : postId)
        let storage = Storage.storage()
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let storageRef = storage.reference()
        let ref = Database.database().reference()
        let key  = ref.childByAutoId().key
        let imageRef = storageRef.child("images/\(String(key)).png")
        
        _ = imageRef.putData(imageData!, metadata: nil, completion: { (metadata,error ) in
            
            guard let metadata = metadata else{
                
                print(error!)
                
                return
                
            }
            let downloadURL = metadata.downloadURL()
            self.imageURL = downloadURL! as NSURL
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
        })
    }
}
