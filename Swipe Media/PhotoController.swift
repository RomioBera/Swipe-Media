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
    
    var userName = ""
    var imgurl = ""
    var postId = " "
    var profileImgUrl = " "
    var isPostLikeed = false
    var likeCount = " "
    var commentCount = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image1 = UIImage(named: "Back Icon")
        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let button1 = UIButton(frame: buttonFrame1)
        button1.addTarget(self, action: #selector(self.addPostButtonAction), for: .touchUpInside)
        button1.setImage(image1, for: .normal)
        let item1 = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = item1
        
        profileName.text = userName
        //profileImg.downloadImg(from: profileImgUrl)
        photoImg.downloadImg(from: imgurl)
        
        photoImg.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: " "))
        profileImg.sd_setImage(with: URL(string: profileImgUrl), placeholderImage: UIImage(named: " "))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    @objc func addPostButtonAction()
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
   
    
    @IBAction func chatBtnAction(_ sender: Any) {
        
        
        showAlertMessage(alertTitle: "Alert", alertMsg: "This part is undert development..")
//        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentController") as! CommentController
//
//        self.navigationController?.pushViewController(commentVC, animated: false)
        
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
                                                self.likeLbl.text = "0 likes"
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
                        }
                            
                            
                        )
                    }
                }
            )}
        })
        
    }
}
