//
//  AddContactController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 27/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddContactController: UIViewController {

    @IBOutlet var followTblview: UITableView!
    
    var postData = [PostData]()
    var fUserData = [FollowUser]()
    var userID = NSMutableArray()
    var keyId = NSMutableArray()
    
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
       
        
    }
    
    @objc func addPostButtonAction()
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        fetchData()
        followUserData()
    }
    
    func fetchData()
    {
        let ref = Database.database().reference()
        ref.child("userProfileData").queryLimited(toFirst: 10).queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            // print(snapshot)
            // print(snapshot.childrenCount)
            
            if snapshot.childrenCount == 0
            {
                return
            }
            let users = snapshot.value as! [String : AnyObject]
            
            
            for (_,value) in users
            {
                
                // =======  let userToShow = PostData()
                
                if let uid = value["userId"] as? String
                {
                    if uid != Auth.auth().currentUser?.uid
                    {
                        let userToShow = PostData()
                        userToShow.imgUrl = value["pathToImage"] as? String
                        userToShow.userName = value ["userName"] as? String
                         userToShow.userId = value ["userId"] as? String
                        self.postData.append(userToShow)
                      
                        
                        
                    }
                }
                
                
                // print(users)
                
                
            }
            
            self.followTblview.reloadData()
            
        })
        
        
        
    }
    
    func followUserData()
    {
        
 
        var uid = Auth.auth().currentUser?.uid
         let ref = Database.database().reference()
         let key = ref.child("following").child(uid!).childByAutoId().key
         var isFollowing = false
         // ref.child("Users").child(uid!).child("following"),,=== ref.child("following").child(uid!)
         // ref.child("newpostss").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with:
         ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: {
         
         snapshot in
         
            if snapshot.childrenCount == 0
            {
               //return
                
                self.userID.removeAllObjects()
            }
            else
            {
                if let following = snapshot.value as? [String : AnyObject]
                {
                    print(following)
                    for (_,value) in following
                    {
                        print(value)
                        //ref.child("newposts").childByAutoId().setValue(feed)
                        print(value["following"])
                        print(value["key"])
                        
                        
                        let followData = FollowUser()
                        
                        followData.key = value["key"] as? String
                        followData.followUser = value ["following"] as? String
                        self.userID.add(followData.followUser)
                        self.fUserData.append(followData)
                        
                    }
                }
                
            }
            
//            DispatchQueue.main.async {
//                self.followTblview.reloadData()
//            }
        self.followTblview.reloadData()
            
         })
        
        
 
     
    }
    

}
extension AddContactController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return self.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactCell", for: indexPath as IndexPath) as! AddContactCell
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        cell.profilePic.downloadImg(from: self.postData[indexPath.row].imgUrl!)
        cell.userName.text = self.postData[indexPath.row].userName
        
      //  let fuser = fUserData[indexPath.row].followUser
     
        print(userID)
        print(postData[indexPath.row].userId)
        
        cell.followBtn.layer.cornerRadius = 5.0
       cell.followBtn.layer.masksToBounds = true
        if (userID.contains(postData[indexPath.row].userId) )
        {
            cell.followBtn.setTitle("UNFOLLOW", for: .normal)
            cell.followBtn.backgroundColor = UIColor.darkGray
        }
        
        else
        {
            cell.followBtn.setTitle("FOLLOW", for: .normal)
            cell.followBtn.backgroundColor = UIColor.blue
        }
 
         cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followButtonAction), for: .touchUpInside)
       
        return cell
    }
    @objc func followButtonAction(sender: UIButton){
        print(sender.tag)
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
       // var isFollowing = false
        
        let keyToPost = ref.child("newposts").childByAutoId().key
        
        
        ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                let updateLikes:[String : Any] = ["follower":uid!,"following" :self.postData[sender.tag].userId,"key":keyToPost ]
                
                ref.child("Users").child(uid!).child("following").child(keyToPost).updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("Users").child(uid!).observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            if let properties = snap.value as? [String: Any]
                            {
                                
                                if let following = properties["following"] as? [String : Any]
                                    
                                {
                                    let count = following.count
                                    //                                    print(count)
                                    let update = ["following" : count]
                                     ref.child("Users").child(uid!).updateChildValues(update)
                                    
                                    // ref.child("newposts").child(key).setValue(feed)
                                    // self.feedTblView.reloadData()
                                }
                                if let follower = properties["follower"] as? [String : Any]
                                    
                                {
                                    let count = follower.count
                                    //                                    print(count)
                                    let update = ["follower" : count]
                                    ref.child("Users").child(uid!).updateChildValues(update)
                                    
                                    // ref.child("newposts").child(key).setValue(feed)
                                    // self.feedTblView.reloadData()
                                }
                            }
                        })
                    }
                }
                )}
            
            self.followTblview.reloadData()
        })
        
        
        
      //  let fuser = fUserData[sender.tag].key
        //if fuser == self.postData[sender.tag].userId
        
        
        
        //=======start
          /*
          if userID.contains(self.postData[sender.tag].userId)
        {
           
         var index = NSInteger()
            for i in uid!
            {
               if (uid!.count) > index
               {
                if userID[index] as! String == (self.postData[sender.tag].userId)
                {
                    print(index)
                    isFollowing = true
                    let  indexKey = fUserData[index].key
                    ref.child("following").child(uid!).child(indexKey!).removeValue()
                    //uid?.remove(at:index)
                    
                    self.followUserData()
                    return
                }
                
                }
                else
               {
                return
                }
               
                index = index + 1
            }
                
            
          
           // ref.child("following").child(uid!).child(indexKey!).removeValue()
            //ref.child("newpostss").child(self.postData[sender.tag].userId).child("following\(key)").removeValue()
            //ref.child("following").child(uid!).childByAutoId().child("following=\(self.postData[sender.tag].userId)").removeValue()
        }
        if !isFollowing
                        {
                           let following = ["following" : self.postData[sender.tag].userId,"key":key]
                           ref.child("following").child(uid!).child(key).setValue(following)
                        }
        
        
        self.followUserData()
     self.followTblview.reloadData()
   */
        //===========end
        
        
        /*
        // ref.child("newpostss").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with:
        ref.child("following").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            snapshot in
            
            if let following = snapshot.value as? [String : AnyObject]
            {
                print(following)
                for (_,value) in following
                {
                    let indexKey = value["key"] as! String
                    if value["following"] as! String == self.postData[sender.tag].userId
                    {
                        isFollowing = true
                        ref.child("following").child(uid!).child(indexKey).removeValue()
                        //ref.child("newpostss").child(self.postData[sender.tag].userId).child("following\(key)").removeValue()
                        //ref.child("following").child(uid!).childByAutoId().child("following=\(self.postData[sender.tag].userId)").removeValue()
                    }
                    
                    
                    
                    
                    
                    
                    print(value)
                    //ref.child("newposts").childByAutoId().setValue(feed)
                    print(value["following"])
                     print(value["key"])
//                    let indexKey = value["key"] as! String
                    print(self.postData[sender.tag].userId)
                    if value["following"] as! String == self.postData[sender.tag].userId
                    {
                        isFollowing = true
                        ref.child("following").child(uid!).child(indexKey).removeValue()
                        //ref.child("newpostss").child(self.postData[sender.tag].userId).child("following\(key)").removeValue()
                        //ref.child("following").child(uid!).childByAutoId().child("following=\(self.postData[sender.tag].userId)").removeValue()
                    }
                }
//                if !isFollowing
//                {
//                    let following = ["following\(key)" : self.postData[sender.tag].userId]
//                    let followers = ["following\(key)": uid]
//
//                    ref.child("newpostss").child(uid!).setValue(following)
//                    ref.child("newpostss").child(self.postData[sender.tag].userId).setValue(followers)
//                }
                
                
                
            }
            
            if !isFollowing
            {
            
                
                let following = ["following" : self.postData[sender.tag].userId,"key":key]
              //  let followers = ["followers\(key)": uid]
                
                ref.child("following").child(uid!).child(key).setValue(following)
                //ref.child("newpostss").child(self.postData[sender.tag].userId).setValue(followers)
            }
            
        })
         
         
         ==============
         let ref = Database.database().reference()
         let keyToPost = ref.child("newposts").childByAutoId().key
         
         
         ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with: {
         
         (snapshot) in
         
         
         if  let post = snapshot.value as? [String : AnyObject]
         {
         let updateLikes:[String : Any] = ["userId":Auth.auth().currentUser?.uid,"commentDescription" :self.postTxt.text,"key":keyToPost ]
         
         ref.child("newposts").child(self.postId).child("peoplewhoComment").child(keyToPost).updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in
         
         if error == nil
         
         {
         ref.child("newposts").child(self.postId).observeSingleEvent(of: .value, with:{
         
         
         (snap) in
         
         if let properties = snap.value as? [String: Any]
         {
         
         if let comments = properties["peoplewhoComment"] as? [String : Any]
         
         {
         let count = comments.count
         //                                    print(count)
         let update = ["comments" : count]
         ref.child("newposts").child(self.postId).updateChildValues(update)
         
         // ref.child("newposts").child(key).setValue(feed)
         // self.feedTblView.reloadData()
         }
         }
         })
         }
         }
         )}
         })
         
         
         ===============
         
        */
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  120
        
    }
    
}
