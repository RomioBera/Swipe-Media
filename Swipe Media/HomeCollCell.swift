//
//  HomeCollCell.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 10/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeCollCell: UICollectionViewCell {
    
    @IBOutlet var postImg: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var favBtn: UIButton!
    @IBOutlet var disLikeBtn: UIButton!
    @IBOutlet var likeLbl: UILabel!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var commentlbl: UILabel!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var reportBtn: UIButton!
    
    
    @IBOutlet var cellLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var commentView: UITextView!
    @IBOutlet var homeTblView: UITableView!
    
    @IBOutlet var showLbl: UILabel!
    
    
    var postId = String()
    var postUserName = String()
    var postUserId = String()
    var getUserName = String()
   
    @IBAction func dislikeBtnAction(_ sender: Any) {
        
        
        
        
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
                            
                            self.favBtn.isHidden = false
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
                                    
                                    self.favBtn.isHidden = true
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
    
    
    @IBAction func reportBtnAction(_ sender: Any) {
    }
    
    
    
    
}
