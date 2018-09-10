//
//  AddPostController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 20/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
import AVKit
import AVFoundation

class AddPostController: UIViewController,btnIndexDelegate {
   
    var loginType = " "
    var userName = " "
    var imageName = String()
    var imagePicker = UIImagePickerController()
    var uploadType = ""
    var videonewURL: NSURL?
    var thumbleURL : NSURL?
   var tabButtonVC : TabButtonController! = nil
    var heightInPoints = Int()
    var widthInPoints = Int()
    
    @IBOutlet var uploadImg: UIImageView!
    
    @IBOutlet var aboutPostTxt: UITextView!
    
    @IBOutlet var addIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn()
        
        
        let image2 = UIImage(named: "Upload Icon.png")
        let buttonFrame2 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(35), height: CGFloat(35))
        let button2 = UIButton(frame: buttonFrame2)
        button2.addTarget(self, action: #selector(self.uploadButtonAction), for: .touchUpInside)
        button2.setImage(image2, for: .normal)
        let item2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItem = item2
        self.addIcon.isHidden = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    

    
    @objc func uploadButtonAction()
    {
        
       // self.navigationController?.popViewController(animated: true)
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        // let storage = Storage.storage().reference(forURL: "gs://swipe-media.appspot.com")
        let key  =  ref.child("postTest").child(uid).childByAutoId().key
        
        if (self.videonewURL == nil)
        {
            self.showAlertMessage(alertTitle: "Error", alertMsg: "Please upload any image or video to post..")
        }
            
        else if (self.uploadType == "video")
        {
            
            let feed = [
                "userId": uid,
                "likes" : 0,
                "comments" : 0,
                "pathToImage" : " ",
                "thumbleImage" : thumbleURL?.absoluteString,
                "postID" : key,
                "pathToVideo" : videonewURL?.absoluteString as Any,
                "post_description" : self.aboutPostTxt.text,
                "userName"      : Auth.auth().currentUser?.displayName ?? userName,
                "imageHeight"   : self.heightInPoints,
                "imageWidth"   : self.widthInPoints,
                "key"           : key
                ] as [String :Any]
            
            //  ref.child("newposts").childByAutoId().setValue(feed)
            //let postFeed = ["\(key)" : feed]
            // ref.child("postss").updateChildValues(postFeed)
            //ref.child("following").child(uid!).child(key).setValue(following)
            ref.child("newposts").child(key).setValue(feed)
            self.dismiss(animated: true, completion: nil)
            
            self.showAlertMessage(alertTitle: "Congratulation", alertMsg: "You sucessfully upload your post..")
            
        }
        else
        {
            
            let feed = [
                "userId": uid,
                "likes" : 0,
                "comments" : 0,
                "pathToImage" : videonewURL?.absoluteString as Any,
                "thumbleImage" : " ",
                "postID" : key,
                "pathToVideo" : " ",
                "post_description" : self.aboutPostTxt.text,
                "userName"      : Auth.auth().currentUser?.displayName ?? userName,
                "imageHeight"   : self.heightInPoints,
                "imageWidth"   : self.widthInPoints,
                "key"           : key
                
                ] as [String :Any]
            
            
            ref.child("newposts").child(key).setValue(feed)
            
            // let postFeed = ["\(key)" : feed]
            // ref.child("posts").updateChildValues(postFeed)
            // ref.child("newposts").childByAutoId().setValue(feed)
            
            // ref.child("posts").child(uid).childByAutoId().setValue(feed)
            
            self.dismiss(animated: true, completion: nil)
            self.showAlertMessage(alertTitle: "Congratulation", alertMsg: "You sucessfully upload your post..")
            
        }
        
        
        
    }

    @IBAction func videoUploadBtnAction(_ sender: Any) {
        
        uploadType = "video"
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
    }
    
    @IBAction func photoUploadBtnAction(_ sender: Any) {
        
        
        uploadType = "photo"
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    
    func getBtnIndex(index: NSInteger) {
        
        if index == 0
            
        {
            uploadType = "photo"
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            uploadType = "video"
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.mediaTypes = ["public.movie"]
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
}

extension AddPostController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @objc  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if self.uploadType == "video"
        {
            let metaData = StorageMetadata()
            metaData.contentType = "video/.mp4"
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                // we selected a video
                print("Here's the file URL: ", videoURL)
                // Where we'll store the video:
                 let ref = Database.database().reference()
                let key  = ref.childByAutoId().key
                let storageReference = Storage.storage().reference().child("User/\(String(key)).mp4")
                
                //
                
                // Start the video storage process
                
                storageReference.putFile(from: videoURL as URL, metadata: nil, completion: { (metadata, error) in
                    if error == nil {
                        print("Successful video upload")
                        
                        guard let metadata = metadata else{
                            
                            print(error!)
                            
                            return
                            
                        }
                        
                        print(metadata)
                        
                        //let fullPath = metadata.path
                        //    print(fullPath)
                        let downloadURL = metadata.downloadURL()
                        self.videonewURL = downloadURL! as NSURL
                        print(downloadURL ?? "0")
                        
                        
                        
                        /// ===========
                        
                        let asset: AVAsset = AVAsset(url: self.videonewURL! as URL)
                        let imageGenerator = AVAssetImageGenerator(asset: asset)
                        
                        do {
                            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
                            
                            print(thumbnailImage)
                            DispatchQueue.main.async(execute: {
                                // assign your image to UIImageView
                                
                                self.uploadImg.image = UIImage(cgImage: thumbnailImage)
                                
                                let imageData = UIImageJPEGRepresentation(self.uploadImg.image!, 0.9)
                                print(imageData!)
                                
                                if(imageData==nil)  {
                                    
                                    self.showAlertMessage(alertTitle: "Error", alertMsg: "Something going wrong try again..")
                                    return
                                    
                                }
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
                                        self.showAlertMessage(alertTitle: "Error", alertMsg: " Video does not upload successfully")
                                         MBProgressHUD.hide(for: self.view, animated: true)
                                        return
                                        
                                    }
                                    
                                    print(metadata)
                                    
                                    ///  let fullPath = metadata.path
                                    //  print(fullPath)
                                    let downloadURL = metadata.downloadURL()
                                    self.thumbleURL = downloadURL! as NSURL
                                    print(downloadURL ?? "0")
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    //self.addIcon.isHidden = false
                                    
                                })
                                
                            })
                            
                        } catch let error {
                            print(error)
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        
                       
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                        
                        
                    } else {
                        print(error!)
                        MBProgressHUD.hide(for: self.view, animated: true)
                       self.showAlertMessage(alertTitle: "Error", alertMsg: "Video does not upload successfully")
                        
                    }
                })
                
            }
            //Dismiss the controller after picking some media
            dismiss(animated: true, completion: nil)
            
            
        }
        else
        {
            
            
            if let image = info[UIImagePickerControllerOriginalImage ] as? UIImage
            {
                
                 self.dismiss(animated: true, completion: nil)
                self.heightInPoints = Int(image.size.height)
                self.widthInPoints = Int(image.size.width)
               
               print(self.heightInPoints)
                print(self.widthInPoints)
                self.uploadImg.image = image
                myImageUploadRequest()
                
//                if (heightInPoints > 400) && (widthInPoints > 300)
//                {
//
//                }
//
//               else
//                {
//                    showAlertMessage(alertTitle: "Alert", alertMsg: "Image size too small..")
//
//                     MBProgressHUD.hide(for: self.view, animated: true)
//                }
                
            }
           
           
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
         MBProgressHUD.hide(for: self.view, animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func myImageUploadRequest()
    {
        
        let imageData = UIImageJPEGRepresentation(self.uploadImg.image!, 0.9)
        print(imageData!)
        
        if(imageData==nil)  {
            
            showAlertMessage(alertTitle: "Error", alertMsg: "Something going wrong try again..")
            return
            
        }
        
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
                self.showAlertMessage(alertTitle: "Error", alertMsg: " Image does not upload successfully")

                return
                
            }
            
            print(metadata)
            
          ///  let fullPath = metadata.path
            //  print(fullPath)
            let downloadURL = metadata.downloadURL()
            self.videonewURL = downloadURL! as NSURL
            print(downloadURL ?? "0")
             MBProgressHUD.hide(for: self.view, animated: true)
            //self.addIcon.isHidden = false
            
        })
        
    }
}




