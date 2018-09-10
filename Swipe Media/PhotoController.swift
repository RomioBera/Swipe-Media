//
//  PhotoController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 24/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class PhotoController: UIViewController {

    
    @IBOutlet var photoImg: UIImageView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var disLikeBtn: UIButton!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var likeLbl: UILabel!
    @IBOutlet var commentLbl: UILabel!
    
    @IBOutlet var deleteView: UIView!
    var userName = ""
    var imgurl = ""
    var postId = " "
    var profileImgUrl = " "
    var isPostLikeed = false
    var likeCount = " "
    var commentCount = " "
    var imgHeight = 1
    var imgWidth = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
        print(imgWidth)
        print(imgHeight)
        backBtn()
        profileName.text = userName
         likeLbl.text = likeCount
        commentLbl.text = commentCount
        
        
        if(( imgWidth > 300) && (imgHeight > 400))
        {
            photoImg.contentMode = .scaleToFill
            photoImg.backgroundColor = UIColor.white
        }
        else
            
        {
            photoImg.contentMode = .scaleAspectFit
            photoImg.backgroundColor = UIColor.black
        }
        
        
        photoImg.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: " "))
        profileImg.sd_setImage(with: URL(string: profileImgUrl), placeholderImage: UIImage(named: " "))
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        deleteView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        deleteView.addGestureRecognizer(tap)
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are sure to delete ?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
            self.deleteView.isHidden = true
            self.deletePost(postId: self.postId)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func deletePost (postId : String)
    {
         let ref = Database.database().reference()
        ref.child("newposts").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
           ref.child("newposts").child(self.postId).removeValue()
            
            self.photoImg.isHidden = true
          
            
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.photoImg.isHidden = false
        
        
        if isPostLikeed == true
        {
            self.likeBtn.isHidden = true
            self.disLikeBtn.isHidden = false
        }
        else
        {
            self.likeBtn.isHidden = false
            self.disLikeBtn.isHidden = true
        }
        
    }
    
  
    
   
    
    @IBAction func chatBtnAction(_ sender: Any) {
        
        
       // showAlertMessage(alertTitle: "Alert", alertMsg: "This part is undert development..")
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentController") as! CommentController

        self.navigationController?.pushViewController(commentVC, animated: false)
        
    }
  
    @IBAction func disLikeBtnAction(_ sender: Any) {
        
        let ref = Database.database().reference()
        // let keyToPost = ref.child("newposts").childByAutoId().key
        ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject]
            {
                if let peopleWholike = properties["peoplewhoLike"] as? [String : AnyObject]
                {
                    for (id,person) in peopleWholike
                    {
                        print(id)
                        print(person)
                        if person as? String == Auth.auth().currentUser?.uid
                        {
                            ref.child("newposts").child(self.postId).child("peoplewhoLike").child(id).removeValue(completionBlock: {
                                (error,reff) in
                                
                                if error == nil
                                {
                                    ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with: {
                                        
                                        (snap) in
                                        if let propertites = snap.value as? [String: AnyObject]
                                        {
                                            if let likes = propertites["peoplewhoLike"] as? [String : AnyObject]
                                            {
                                                let count = likes.count
                                                self.likeLbl.text = String(count)
                                                
                                                let update = ["likes" : count]
                                                ref.child("newposts").child(self.postId).updateChildValues(update)
                                            }
                                            else
                                            {
                                                let update = ["likes" : 0]
                                                self.likeLbl.text = "0 "
                                                ref.child("newposts").child(self.postId).updateChildValues(update)
                                            }
                                            
                                        }
                                        
                                    })
                                }
                                
                                
                            })
                            
                            self.likeBtn.isHidden = false
                            self.disLikeBtn.isHidden = true
                            
                            break
                            
                            
                        }
                        
                        //break
                    }
                }
            }
            
        })
        
        
    }


    @IBAction func likeBtnAction(_ sender: Any) {
        
        let ref = Database.database().reference()
        let keyToPost = ref.child("newposts").childByAutoId().key
        
        
        ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                let updateLikes:[String : Any] = ["peoplewhoLike/\(keyToPost)":Auth.auth().currentUser?.uid]
                
                ref.child("newposts").child(self.postId).updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            if let properties = snap.value as? [String: Any]
                            {
                                
                                if let likes = properties["peoplewhoLike"] as? [String : Any]
                                    
                                {
                                    let count = likes.count
                                    self.likeLbl.text = String(likes.count)
                                    
                                    print(count)
                                    let update = ["likes" : count]
                                    ref.child("newposts").child(self.postId).updateChildValues(update)
                                    
                                    self.likeBtn.isHidden = true
                                    self.disLikeBtn.isHidden = false
                                    
                                    
                                    // self.feedTblView.reloadData()
                                }
                            }
                        })
                    }
                }
            )}
        })
        
    }
    
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        
        deleteView.isHidden = false
    }
    
    
}
