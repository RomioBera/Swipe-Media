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
    
    var userAllData = [UserData]()
    var userID = NSMutableArray()
    var keyId = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       backBtn()
       
        
    }
    
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        userAllData.removeAll()
        userID.removeAllObjects()
        fetchNewDatabase()
    }
    
    
    func fetchNewDatabase()
    {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("Users").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            let users = snapshot.value as! [String : AnyObject]
            for (_,value) in users
            {
                
                if let uid = value["userId"] as? String
                {
                    if uid != Auth.auth().currentUser?.uid
                    {
                        
                        
                        let userToShow = UserData()
                        userToShow.userProfileImg = value["profilePic"] as? String
                        userToShow.userName = value ["userName"] as? String
                        userToShow.userId = value ["userId"] as? String
                        userToShow.followingCount = value["followingCount"] as? Int
                        
                        print("follow count = ",userToShow.followingCount)
                        
                        print(value["following"])
                        
                         self.userAllData.append(userToShow)
                        
                    }
                    
                }
            }
            
          self.followTblview.reloadData()
            
           
            
    })
        
        ref.child("Users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
            if snapshot.childrenCount == 0
            {
                return
            }
            let users = snapshot.value as! [String : AnyObject]
            
            print(users)
            for (_,value) in users
            {
                print(users)
                
                 self.userID.add(value["following"])
                
            }
            
           print("userId",self.userID)
            
        })
        
        
        
}
    
   

}
extension AddContactController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return self.userAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactCell", for: indexPath as IndexPath) as! AddContactCell
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        cell.profilePic.sd_setImage(with: URL(string: self.userAllData[indexPath.row].userProfileImg!), placeholderImage: UIImage(named: "Profile Icon"))
        cell.userName.text = self.userAllData[indexPath.row].userName
        
    
        
        cell.followBtn.layer.cornerRadius = 5.0
       cell.followBtn.layer.masksToBounds = true
        
        cell.unfollowBtn.layer.cornerRadius = 5.0
        cell.unfollowBtn.layer.masksToBounds = true
        
        
        if (userID.contains(userAllData[indexPath.row].userId) )
        {
           cell.followBtn.isHidden = true
            cell.unfollowBtn.isHidden = false
        }

        else
        {
            cell.followBtn.isHidden = false
            cell.unfollowBtn.isHidden = true
            
        }

        
         cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followButtonAction), for: .touchUpInside)
        
        cell.unfollowBtn.tag = indexPath.row
        cell.unfollowBtn.addTarget(self, action: #selector(unfollowButtonAction), for: .touchUpInside)
       
        return cell
    }
    
    
    @objc func followButtonAction(sender: UIButton){
        print(sender.tag)
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
      
         self.userID.add(userAllData[sender.tag].userId)
        ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                let updateLikes:[String : Any] = ["following" :self.userAllData[sender.tag].userId ]
                
                ref.child("Users").child(uid!).child("following").child(self.userAllData[sender.tag].userId).updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("Users").child(uid!).child("following").observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            let count = snap.childrenCount
                            //                                    print(count)
                            let update = ["followingCount" : count]
                            ref.child("Users").child(uid!).updateChildValues(update)
                          
                        })
                    }
                }
            )}
            
            self.followTblview.reloadData()
        })
        
        
        
        
        ref.child("Users").child(self.userAllData[sender.tag].userId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                let updateLikes:[String : Any] = ["follower":uid!]
                
                ref.child("Users").child(self.userAllData[sender.tag].userId).child("followers").updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("Users").child(self.userAllData[sender.tag].userId).child("followers").observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            let count = snap.childrenCount
                            let update = ["followersCount" : count]
                            ref.child("Users").child(self.userAllData[sender.tag].userId).updateChildValues(update)
                           
                        })
                    }
                }
            )}
            
             //self.followTblview.reloadData()
            //self.fetchNewDatabase()
        })
        
        
      
    }
    
    @objc func unfollowButtonAction(sender: UIButton){
        print(sender.tag)
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        self.userID.remove(self.userAllData[sender.tag].userId)
       
        ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                
                ref.child("Users").child(uid!).child("following").child(self.userAllData[sender.tag].userId).removeValue(completionBlock: {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("Users").child(uid!).child("following").observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            let count = snap.childrenCount
                            //                                    print(count)
                            let update = ["followingCount" : count]
                            ref.child("Users").child(uid!).updateChildValues(update)
                           
                        })
                    }
                }
                )}
            
             self.followTblview.reloadData()
        })
        
        
        
        
        ref.child("Users").child(self.userAllData[sender.tag].userId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
            if  let post = snapshot.value as? [String : AnyObject]
            {
                
                //removeValue(completionBlock: {
                ref.child("Users").child(self.userAllData[sender.tag].userId).child("followers").removeValue(completionBlock : {(error,reff) in
                    
                    if error == nil
                        
                    {
                        ref.child("Users").child(self.userAllData[sender.tag].userId).child("followers").observeSingleEvent(of: .value, with:{
                            
                            
                            (snap) in
                            
                            let count = snap.childrenCount
                            //                                    print(count)
                            let update = ["followersCount" : count]
                            ref.child("Users").child(self.userAllData[sender.tag].userId).updateChildValues(update)
                            
                        })
                    }
                }
                )}
            
             self.followTblview.reloadData()
           // self.fetchNewDatabase()
        })
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  120
        
    }
    
}
