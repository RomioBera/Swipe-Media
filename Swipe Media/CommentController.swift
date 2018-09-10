 //
//  CommentController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 30/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import MBProgressHUD
 
class CommentController: UIViewController {

    
    var postId = " "
    var allCommentData = [PostData]()
     var userProfileData = [UserProfileData]()
    var userData = [UserData]()
    
    @IBOutlet var commentTblView: UITableView!
    
    var height = CGFloat()
    var commentArray = ["In iOS 8, Apple introduces a new feature for UITableView known as Self Sizing Cells. To me, this is seriously one of the most exciting features for the new SDK. Prior to iOS 8, if you want to display dynamic content in table view with variable height, you would need to calculate the row height manually. Now with iOS 8, ","Self Sizing Cell provides a solution for displaying dynamic content. In brief, here are what you need to do when using self sizing cells:","With just two lines of code, you instruct the table view to calculate the cell’s size matching its content and render it dynamically. This self sizing cell feature should save you tons of code and time. You’re gonna love it.","There is no better way to learn a new feature than using it. We’ll develop a simple demo app to demonstrate self sizing cell."]
    
    @IBOutlet var postTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image1 = UIImage(named: "Back Icon")
        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let button1 = UIButton(frame: buttonFrame1)
        button1.addTarget(self, action: #selector(self.backButtonAction), for: .touchUpInside)
        button1.setImage(image1, for: .normal)
        let item1 = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = item1
        
//        commentTblView.rowHeight = UITableViewAutomaticDimension
//        commentTblView.estimatedRowHeight = 100
        //commentTblView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
       allCommentData.removeAll()
      userProfileData.removeAll()
        userData.removeAll()
        fetchCommentData()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
    }
    @objc func backButtonAction()
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func fetchCommentData()
    {
        let ref = Database.database().reference()
       
        self.allCommentData.removeAll()
        ref.child("newposts").child(self.postId).child("peoplewhoComment").queryLimited(toFirst: 10).queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
            if snapshot.childrenCount == 0
            {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            let users = snapshot.value as! [String : AnyObject]
            for (_,value) in users
            {
                print(users)
            
                if (value["userId"] as? String) != nil
                {
                    let userToShow = PostData()
                    userToShow.postId = value["key"] as? String
                    userToShow.userId = value["userId"] as? String
                    userToShow.postDes = value["commentDescription"] as? String
                   // print(value["key"] as? String)

                    self.allCommentData.append(userToShow)
                     self.fetchAllNewUserProfileData(userId:(value["userId"] as? String)! )
                    
                    
                }
            }
            
            //self.commentTblView.reloadData()
            
        })
        
    }
    
    func fetchAllNewUserProfileData(userId:String)
    {
        
       // let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Users").child(userId)
         let uData = UserData()
        
        ref.observe(.value, with:{ (snapshot) in
            
            print("snapshot : ", snapshot)
            
            if snapshot.childrenCount == 0
            {
                //self.profilePicArray.add(" ")
              
                uData.userName = " "
                uData.userProfileImg = " "
                uData.userId = userId
                self.userData.append(uData)
            }
                
            else
            {
                
                
                let users = snapshot.value as! [String : AnyObject]
               // let profileImg = users["profilePic"] as? String
                //let uData = UserData()
                uData.userName = users["userName"] as? String
                uData.userProfileImg = users["profilePic"] as? String
                uData.userId = users["userId"] as? String
                
                self.userData.append(uData)
                
               
                
            }
            
            //  print(self.profilePicArray)
            
            DispatchQueue.main.async { [unowned self] in
                
                
                print(self.userData)
                self.commentTblView.dataSource = self
                self.commentTblView.delegate = self
                self.commentTblView.reloadData()
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        
        
        
        
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        
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
                                     //self.feedTblView.reloadData()
                                }
                            }
                        })
                    }
                }
            )}
            
//            self.commentTblView.reloadData()
            
            self.fetchCommentData()
        })
        
    }
    
}

extension CommentController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(allCommentData.count)
        print(userData.count)
        if (allCommentData.count == userData.count)
        {
            return allCommentData.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentTblView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath as IndexPath) as! CommentCell
        self.commentTblView.separatorColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
         cell.userImg.layer.cornerRadius =  cell.userImg.frame.size.width / 2
        cell.userImg.clipsToBounds = true
        
        if (userData[indexPath.row].userProfileImg) as String == " "
        {
            
        }
        else
        {
             cell.userImg.sd_setImage(with: URL(string: userData[indexPath.row].userProfileImg ),placeholderImage: UIImage(named: " "))
        }
    
       cell.commentTxt.text = allCommentData[indexPath.row].postDes

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        
    }
    
  
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       return 80

    }
    
}
