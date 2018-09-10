//
//  ProfileController.swift
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
import SDWebImage



class ProfileController: UIViewController {
   
    

    @IBOutlet var followersLbl: UILabel!
    @IBOutlet var followingLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var profileCollView: UICollectionView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var homeScreenTblview: UITableView!
    @IBOutlet var postView: UIView!
    
    @IBOutlet var homeCollView: UICollectionView!
    var videoURL = " "
    var profileImgUrl = " "
    var profilePicArray = NSMutableArray()
    var postData = [PostData]()
    var postAllUserData = [PostData]()
    var userProfileData = [UserProfileData]()
    var userData = [UserData]()
    var searchData = [UserProfileData]()
    var loginType = ""
    var imageName = String()
    var imagePicker = UIImagePickerController()
    var uploadType = ""
    var videonewURL: NSURL?
    var sliderVC: SliderController! = nil
    var tabButtonVC : TabButtonController! = nil
    var ispostLiked = false
    var searchingName = " "
    var textField = UITextField()
    var selectedIndex = NSInteger()
    
    @IBOutlet var reportView: UIView!
    
    @IBOutlet var reportedTxt: UITextView!
    
    @IBAction func confirmReportBtnAction(_ sender: Any) {
        
         self.reportView.isHidden = true
        self.homeCollView.isUserInteractionEnabled = true
        
        let ref = Database.database().reference()
        let keyToPost = ref.childByAutoId().key
        
        let feed = [
            
            "postID" : self.postAllUserData[selectedIndex].postId,
            "reportby_userId"       :  Auth.auth().currentUser?.uid,
            "reportby_userName"     : self.userNameLbl.text!,
            "postby_userId"         : self.postAllUserData[selectedIndex].userId,
            "postby_userName"       : self.postAllUserData[selectedIndex].userName,
            "reportDescription"     : self.reportedTxt.text!,
            "key"                   : keyToPost
            
            ] as [String :Any]
        
        
        
        ref.child("Admin").child("Reported Post").child(self.postAllUserData[selectedIndex].postId).child(keyToPost).updateChildValues(feed)
        
        
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        
         self.reportView.isHidden = true
        self.homeCollView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
        self.profileImg.clipsToBounds = true
        
        postView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        
        self.view?.addSubview(postView)
        self.view.isHidden = false;
        
        self.reportView.layer.cornerRadius = 10.0
        self.reportView.clipsToBounds = true
    }
    // cross btn action: - Mark
    @IBAction func crossBtnAction(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.view.isHidden = false
        postView.removeFromSuperview()
        
        sliderVC = self.storyboard?.instantiateViewController(withIdentifier: "SliderController") as? SliderController
        sliderVC.view.frame = CGRect(x: CGFloat(-250), y: CGFloat(64), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        
        
        
        self.view?.addSubview(sliderVC.view)
        sliderVC.view.isHidden = true;
        sliderVC.sliderDelegate=self
        
        tabButtonVC = self.storyboard?.instantiateViewController(withIdentifier: "TabButtonController") as? TabButtonController
                tabButtonVC.view.frame = CGRect(x: CGFloat(0), y: CGFloat((self.view.frame.size.height) - 60 ), width: CGFloat((self.view.frame.size.width)), height: CGFloat(60))
        
        
                tabButtonVC.btnView.backgroundColor = UIColor.clear
                self.view?.addSubview(tabButtonVC.view)
                tabButtonVC.btnView.isHidden = false
               tabButtonVC.tabbarDelegate = self
        
        setDefaultNav()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
        if SingleToneClass.shared.selectedBtn  == " "
        {
            self.navigationController?.isNavigationBarHidden = true
            
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.postData.removeAll()
        self.profilePicArray.removeAllObjects()
        postAllUserData.removeAll()
        userProfileData.removeAll()
        userData.removeAll()
       
        
        fetchUserProfileData()
        fetchUserProfilePosts()
        fetchAllUserPost()
        
        
    }
    
    
    //  Fetch for User profile
    
    func fetchUserProfileData ()
    {
        
        if SingleToneClass.shared.selectedUser == " "
        {
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            //.queryOrderedByKey()
            ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: {
                
                (snapshot) in
                
                // print(snapshot)
                
                
                let users = snapshot.value as! [String : AnyObject]
                self.profileImgUrl = (users["profilePic"] as! String)
                self.followersLbl.text = String(users["followersCount"] as! Int)
                self.followingLbl.text = String(users["followingCount"] as! Int)
                
                self.profileImg.sd_setImage(with: URL(string: (users["profilePic"] as! String)),placeholderImage: UIImage(named: "User"))
                
                self.userNameLbl.text = (users["userName"] as! String)
                
                
            })
        }
        
       else
        {
           
            let ref = Database.database().reference()
            //.queryOrderedByKey()
            ref.child("Users").child(SingleToneClass.shared.selectedUser).observeSingleEvent(of: .value, with: {
                
                (snapshot) in
                
                // print(snapshot)
                
                
                let users = snapshot.value as! [String : AnyObject]
                self.profileImgUrl = (users["profilePic"] as! String)
                self.followersLbl.text = String(users["followersCount"] as! Int)
                self.followingLbl.text = String(users["followingCount"] as! Int)
                
                self.profileImg.sd_setImage(with: URL(string: (users["profilePic"] as! String)),placeholderImage: UIImage(named: "User"))
                
                self.userNameLbl.text = (users["userName"] as! String)
                
                
            })
        }
        
}
    
    @IBAction func editButtonAction(_ sender: Any) {
        
        
         SingleToneClass.shared.selectedBtn = " Edit Profile" 
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        
        editProfileVC.userName = self.userNameLbl.text!
        editProfileVC.imgUrl = self.profileImgUrl
        self.navigationController?.pushViewController(editProfileVC, animated: false)
        
    }
    
    // Data fetch for collectionview : - Personal Post Data Fetch
    func fetchUserProfilePosts()
    {
        let ref = Database.database().reference()
        ref.child("newposts").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
           // print(snapshot)
            
            if snapshot.childrenCount == 0
            {
                return
            }
            let users = snapshot.value as! [String : AnyObject]
            
            //self.postData.removeAll()
            
            for (_,value) in users
            {
                if let uid = value["userId"] as? String
                {
                    
                     if SingleToneClass.shared.selectedUser == " "
                     {
                        if uid == Auth.auth().currentUser?.uid
                        {
                            
                            
                            let userToShow = PostData()
                            userToShow.postId = value["postID"] as? String
                            userToShow.userId = value["userId"] as? String
                            userToShow.postDes = value["post_description"] as? String
                            userToShow.imgUrl = value["pathToImage"] as? String
                            userToShow.userName = value ["userName"] as? String
                            userToShow.videoUrl = value ["pathToVideo"] as? String
                            userToShow.thumbleImage = value["thumbleImage"] as? String
                            userToShow.imageHeight = value ["imageHeight"] as? Int
                            userToShow.imageWidth = value["imageWidth"] as? Int
                            userToShow.likes = value ["likes"] as? Int
                            userToShow.comments = value ["comments"] as? Int
                            
                            
                            if let people = value["peoplewhoLike"] as? [String: AnyObject]
                            {
                                for (_,person) in people
                                {
                                    userToShow.peopleWholike.append(person as! String)
                                }
                            }
                            
                            self.postData.append(userToShow)
                        }
                    }
                    else
                    
                     {
                        if uid == SingleToneClass.shared.selectedUser
                        {
                            
                            
                            let userToShow = PostData()
                            userToShow.postId = value["postID"] as? String
                            userToShow.userId = value["userId"] as? String
                            userToShow.postDes = value["post_description"] as? String
                            userToShow.imgUrl = value["pathToImage"] as? String
                            userToShow.userName = value ["userName"] as? String
                            userToShow.videoUrl = value ["pathToVideo"] as? String
                            userToShow.thumbleImage = value["thumbleImage"] as? String
                            userToShow.imageHeight = value ["imageHeight"] as? Int
                            userToShow.imageWidth = value["imageWidth"] as? Int
                            userToShow.likes = value ["likes"] as? Int
                            userToShow.comments = value ["comments"] as? Int
                            
                            
                            if let people = value["peoplewhoLike"] as? [String: AnyObject]
                            {
                                for (_,person) in people
                                {
                                    userToShow.peopleWholike.append(person as! String)
                                }
                            }
                            
                            self.postData.append(userToShow)
                        }
                    }
                    
                }
             
            }
            
            self.profileCollView.reloadData()
            
        })
        
        
    }
    
    
    // value fetch for Home Screen  All user Post Data in Tableview:- Mark
    
    func fetchAllUserPost()
    {
        let ref = Database.database().reference()
        ref.child("newposts").queryLimited(toFirst: 20).queryOrderedByKey().observeSingleEvent(of: .value, with: {
                
                (snapshot) in
               
                if snapshot.childrenCount == 0
                {
                    return
                }
                let users = snapshot.value as! [String : AnyObject]
                for (_,value) in users
                {
                    
                    if let uid = value["userId"] as? String
                    {
                        if uid != Auth.auth().currentUser?.uid
                        {
                            let userToShow = PostData()
                            userToShow.postId = value["postID"] as? String
                            userToShow.userId = value["userId"] as? String
                            userToShow.postDes = value["post_description"] as? String
                            userToShow.imgUrl = value["pathToImage"] as? String
                            userToShow.userName = value ["userName"] as? String
                            userToShow.videoUrl = value ["pathToVideo"] as? String
                            userToShow.likes = value ["likes"] as! Int
                            userToShow.comments = value ["comments"] as! Int
                            userToShow.imageHeight = value ["imageHeight"] as! Int
                            userToShow.imageWidth = value ["imageWidth"] as! Int
                            userToShow.thumbleImage = value["thumbleImage"] as! String
                            
                            
                            if let people = value["peoplewhoLike"] as? [String: AnyObject]
                            {
                                for (_,person) in people
                                {
                                    userToShow.peopleWholike.append(person as! String)
                                }
                            }
                            self.postAllUserData.append(userToShow)
                            self.fetchAllUserProfileData(userId:(value["userId"] as? String)! )
                            
                        }
                    }
                }
            })
        
        }
    
    
    // Data fetch for Profile of all user -
    
    func fetchAllUserProfileData(userId : String)
  {
    
 
  //  let ref = Database.database().reference().child("userProfileData").queryOrdered(byChild: "userId").queryEqual(toValue : postId)
    let ref = Database.database().reference().child("Users").child(userId)
    let uData = UserData()
    ref.observe(.value, with:{ (snapshot) in
        
       // print(snapshot)
        
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

            
          //  let profileImg = users["profilePic"] as? String
            
//            let uData = UserData()
            
            uData.userName = users["userName"] as? String
            uData.userProfileImg = users["profilePic"] as? String
            uData.userId = users["userId"] as? String
            
        self.userData.append(uData)
            
         
        }
     
        DispatchQueue.main.async { [unowned self] in
            self.homeCollView.reloadData()
        }
        MBProgressHUD.hide(for: self.view, animated: true)
        
    })
    // ref.removeAllObservers()
    }


    
    
    

    func setDefaultNav()
    {
        let image1 = UIImage(named: "Menu Icon")
        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let button1 = UIButton(frame: buttonFrame1)
        button1.addTarget(self, action: #selector(self.menuTabButtonAction), for: .touchUpInside)
        button1.setImage(image1, for: .normal)
        let item1 = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = item1
        
//        if UserDefaults.standard.value(forKey: "loginType") as! String == "emailpassword"
//        {
//            if UserDefaults.standard.object(forKey: "userName") == nil
//            {
//                self.title = "unknown"
//            }
//            else
//            {
//                self.title = UserDefaults.standard.value(forKey: "userName") as? String
//            }
//
//        }
//        else
//        {
//            self.title = Auth.auth().currentUser?.displayName
//        }
        
    }
    
    func setAddPostNav()
    {
//        let image1 = UIImage(named: "Back Icon")
//        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
//        let button1 = UIButton(frame: buttonFrame1)
//        button1.addTarget(self, action: #selector(self.addPostButtonAction), for: .touchUpInside)
//        button1.setImage(image1, for: .normal)
//        let item1 = UIBarButtonItem(customView: button1)
//        self.navigationItem.leftBarButtonItem = item1
        
        backBtn()
    }
    
    
    func setSearchNav()
    {
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 50.0))
        customView.backgroundColor = UIColor.clear
        
        let button = UIButton.init(type: .custom)
        // button.setBackgroundImage(UIImage(named: "Search Icon"), for: .normal)
        button.setImage(UIImage(named: "Search Icon"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 5.0, width: 40.0, height: 30.0)
        button.addTarget(self, action: #selector(menuOpen), for: .touchUpInside)
        customView.addSubview(button)
        
        textField = UITextField(frame: CGRect(x: 60, y: 0.0, width: 200.0, height: 40.0))
        textField.textAlignment = NSTextAlignment.left
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: (textField.font?.fontName)!, size: 15)
        textField.placeholder = "search "
        
        
        
        customView.addSubview(textField)
        
        
        let button2 = UIButton.init(type: .custom)
        button2.frame = CGRect(x: 265.0, y: 5.0, width: 60.0, height: 30.0)
        button2.setTitle("search", for: .normal)
        
        button2.addTarget(self, action: #selector(menuOpen), for: .touchUpInside)
        customView.addSubview(button2)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        self.title = " "
    }
    @objc func  menuOpen()
    {
        
        
        let ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "userName").queryStarting(atValue: textField.text).queryEnding(atValue: textField.text! + "\u{f8ff}").observe(.value, with: { snapshot in
           
            
            print(snapshot)
           
            
            
              let users = snapshot.value as! [String : AnyObject]
            
            for (_,value) in users
            {
                
                let userToShow = UserProfileData()
                userToShow.getUserName = value["userName"] as? String
                userToShow.getImagePath = value["profilePic"] as? String
                print(value["userName"] as? String)
                self.searchData.append(userToShow)
            }
            
            
            
        })
        
        
        
    }
    
    @objc func menuTabButtonAction()
    {
        sliderVC.sliderTblview.reloadData()
        
        
        if sliderVC.view.frame.origin.x < 0 {
            
            
            sliderVC.view.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                
                self.sliderVC.view.frame = CGRect(x: CGFloat(0), y: (64), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
                
            })
        }
        else {
            slideViewHideAnimation()
        }
        
        
    }
    func slideViewHideAnimation() {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            
            self.sliderVC.view.frame = CGRect(x: CGFloat(-250), y: CGFloat(64), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height) )
            
        }, completion: {(_ finished: Bool) -> Void in
            self.sliderVC.view.isHidden = true
        })
    }
    
    func logoutAction()
    {
        
        SingleToneClass.shared.selectedBtn = " "
        
        let alertController = UIAlertController(title: "Alert", message: "Are sure to logout?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.popViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            
            
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
    
    
    
    @IBAction func addProfilePicBtnAction(_ sender: Any) {
        
        
        uploadType = "photo"
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func playExternalVideo(){
        
        let videoURL = URL(string: self.videoURL)
        
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            () -> Void in
            playerViewController.player!.play()
        }
        
    }
    
    
    @IBAction func reportBtnAction(_ sender: Any) {
        
        
        
        
    }
    
    
    
    
}


extension ProfileController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == profileCollView
        {
            return self.postData.count
        }
        else
        {
            if (postAllUserData.count == userData.count)
            {
                return (postAllUserData.count )
            }
            else
                
            {
                return 0
            }
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
      
        
        if collectionView == profileCollView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollCell", for: indexPath as IndexPath) as! ProfileCollCell
            
            if (self.postData[indexPath.row].imgUrl! == " ")
            {
                cell.uploadImg.sd_setImage(with: URL(string: self.self.postData[indexPath.row].thumbleImage!), placeholderImage: UIImage(named: " "))
                cell.videoIcon.isHidden = false
                
                
                cell.profileVideoPlayBtn.isHidden = false
                
            }
            else
            {
                
                print(self.postData[indexPath.row].imgUrl!)
                //cell.uploadImg.downloadImg(from: self.postData[indexPath.row].imgUrl!)
                cell.uploadImg.sd_setImage(with: URL(string: self.self.postData[indexPath.row].imgUrl!), placeholderImage: UIImage(named: " "))
                
                cell.videoIcon.isHidden = true
                cell.profileVideoPlayBtn.isHidden = true
                
            }
            print(self.postData[indexPath.row].videoUrl)
            
            return cell
        }
        
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath as IndexPath) as! HomeCollCell
            
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
            cell.userImage.clipsToBounds = true
            cell.commentBtn.tag = indexPath.row
            cell.favBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
            cell.postId = postAllUserData[indexPath.row].postId
            cell.postUserName = postAllUserData[indexPath.row].userName
            cell.postUserId = postAllUserData[indexPath.row].userId
            cell.getUserName = self.userNameLbl.text!
            cell.likeLbl.text = String( postAllUserData[indexPath.row].likes)
            cell.commentlbl.text = String( postAllUserData[indexPath.row].comments)
            
            cell.reportBtn.tag = indexPath.row
            cell.reportBtn.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
            
            
            if postAllUserData[indexPath.row].userId == userData[indexPath.row].userId
            {
                cell.userImage.sd_setImage(with: URL(string: userData[indexPath.row].userProfileImg as! String),placeholderImage: UIImage(named: " "))
            }
            
            if self.postAllUserData[indexPath.row].imgUrl == " "
            {
                //cell.playBtn.isHidden = false
                cell.postImg.sd_setImage(with: URL(string: self.postAllUserData[indexPath.row].thumbleImage!), placeholderImage: UIImage(named: " "))
                self.videoURL = self.postAllUserData[indexPath.row].videoUrl
                playExternalVideo()
            }
            else
            {
                cell.playBtn.isHidden = true
                
                // cell.postImg.downloadImg(from: self.postAllUserData[indexPath.row].imgUrl!)
                cell.postImg.sd_setImage(with: URL(string: self.postAllUserData[indexPath.row].imgUrl!), placeholderImage: UIImage(named: " "))
                
                
                if(( (postAllUserData[indexPath.row].imageWidth) > 300) && (postAllUserData[indexPath.row].imageHeight) > 400)
                {
                    cell.postImg.contentMode = .scaleToFill
                    cell.contentView.backgroundColor = UIColor.white
                }
                else
                    
                {
                    cell.postImg.contentMode = .scaleAspectFit
                    cell.contentView.backgroundColor = UIColor.black
                }
                
                
                
            }
            
            cell.userName.text = userData[indexPath.row].userName!
            // cell.userName.layer.masksToBounds = true
            // cell.userName.layer.shadowColor = UIColor.red.cgColor
             //cell.userName.layer.shadowOpacity = 0.5
            
            if (self.postAllUserData[indexPath.row].peopleWholike.count == 0)
            {
                cell.favBtn.isHidden = false
                cell.disLikeBtn.isHidden = true
            }
                
            else
            {
                for person in self.postAllUserData[indexPath.row].peopleWholike
                {
                    
                    if person == Auth.auth().currentUser?.uid
                    {
                        cell.favBtn.isHidden = true
                        cell.disLikeBtn.isHidden = false
                        break
                    }
                    else
                    {
                        cell.favBtn.isHidden = false
                        cell.disLikeBtn.isHidden = true
                        
                    }
                }
            }
            
           
            
            return cell
        }
       
    }

    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
      
        SingleToneClass.shared.selectedBtn = "Photo"
        
        if collectionView == profileCollView
        {
            if self.postData[indexPath.row].videoUrl == " "
            {
                
                if self.postData[indexPath.row].peopleWholike.count == 0
                {
                    ispostLiked = false
                }
                else
                    
                {
                    
                    for person in self.postData[indexPath.row].peopleWholike
                    {
                        
                        if person == Auth.auth().currentUser?.uid
                        {
                            ispostLiked = true
                            break
                        }
                        else
                        {
                            ispostLiked = false
                            
                        }
                    }
                }
                
                
                let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
                
                
                
                regVC.userName = self.userNameLbl.text!
                regVC.imgurl = postData[indexPath.row].imgUrl
                regVC.isPostLikeed = ispostLiked
                regVC.postId = postData[indexPath.row].postId
                regVC.profileImgUrl = profileImgUrl
                regVC.likeCount = String(postData[indexPath.row].likes)
                regVC.commentCount = String(postData[indexPath.row].comments)
                regVC.imgHeight = postData[indexPath.row].imageHeight
                regVC.imgWidth = postData[indexPath.row].imageWidth
                
                self.navigationController?.pushViewController(regVC, animated: false)
            }
            else
            {
                self.videoURL = self.postData[indexPath.row].videoUrl
                
                playExternalVideo()
            }
            
        }
        
 else
        
        {
            if self.postAllUserData[indexPath.row].videoUrl == " "
            {
//                let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
//
//
//                regVC.userName = postAllUserData[indexPath.row].userName
//                regVC.imgurl = postAllUserData[indexPath.row].imgUrl
//                regVC.postId = postAllUserData[indexPath.row].postId
//
//                self.tabBarController?.navigationController?.pushViewController(regVC, animated: false)
            }
            else
            {
                self.videoURL = self.postAllUserData[indexPath.row].videoUrl
                
                playExternalVideo()
            }
            
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  return CGSize(width: ((self.view.frame.width / 3)-20), height: 100)
        
        if collectionView == profileCollView
        {
             return CGSize(width: ((self.view.frame.width / 3)), height: ((self.view.frame.width / 3)))
        }
        else
        
        {
             return CGSize(width: ((self.view.frame.width)), height: ((self.view.frame.height)))
        }
       
        
    }

}


extension ProfileController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @objc  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
            
            if let image = info[UIImagePickerControllerEditedImage ] as? UIImage
            {

                self.profileImg.image = image
            }
            myImageUploadRequest()
            self.dismiss(animated: true, completion: nil)
            
            
        
    }
    
    func myImageUploadRequest()
    {
        
        let imageData = UIImageJPEGRepresentation(self.profileImg.image!, 0.9)

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
                
//                print(error!)
//
                return
                
            }
            let downloadURL = metadata.downloadURL()
            self.videonewURL = downloadURL! as NSURL
            let uid = Auth.auth().currentUser!.uid
           
            
            if (self.videonewURL == nil)
            {
                self.showAlertMessage(alertTitle: "Error", alertMsg: "Please upload any image or video to post..")
            }
            else
            {
               // let key  = ref.child("userProfileData").childByAutoId().key
                let refnew = Database.database().reference().child("Users").child(uid)
                
                refnew.observe(.value, with:{ (snapshot) in
                    
                    let feed = [

                        "profilePic" : self.videonewURL?.absoluteString as Any,

                        ]
                
                    refnew.updateChildValues(feed)
                    
                })
            }
            
          
    })
 }
}
extension ProfileController : sliderIndexDelegate

{
    func viewButtonClicked(isClick: String) {
        
    }
    
    
    
   
    func getSliderIndex(index: NSInteger) {
        
        SingleToneClass.shared.selectedBtn = "Menu Btn Clicked"
        
        if index == 0
        {
            let addContractVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController

            self.navigationController?.pushViewController(addContractVC, animated: true)
            slideViewHideAnimation()

        }
        
//        else if (index == 1)
//        {
//            setProfileNav()
//
//            slideViewHideAnimation()
//        }
        else if (index == 4)
        {
            logoutAction()
        }
            
        else
        {
            let alertController = UIAlertController(title: "Alert", message: "This part is under development...", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                self.slideViewHideAnimation()
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func setProfileNav ()
    {
        let image1 = UIImage(named: "more.png")
        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(13), height: CGFloat(22))
        let button1 = UIButton(frame: buttonFrame1)
        button1.addTarget(self, action: #selector(self.menuTabButtonAction), for: .touchUpInside)
        button1.setImage(image1, for: .normal)
        let item1 = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = item1
    }
}


extension ProfileController : tabbarIndexDelegate
{
    func getTabbarIndex(index: NSInteger) {
        
        if (index == 1)
        {
            
            setDefaultNav()
            
            SingleToneClass.shared.selectedBtn   = "Add Post "
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPostController") as! AddPostController
            homeVC.userName = self.userNameLbl.text!
            self.navigationController?.pushViewController(homeVC, animated: false)
            
            
        }
        else if (index == 2)
            
        {
            SingleToneClass.shared.selectedBtn   = " Search"
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
           
            self.navigationController?.pushViewController(homeVC, animated: false)
            
            
           // setSearchNav()
            
        }
        else if (index == 0)
        {
            SingleToneClass.shared.selectedBtn   = " "
            self.navigationController?.isNavigationBarHidden = true
            tabButtonVC.btnView.isHidden = true
            postView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
            
            
            
            self.view?.addSubview(postView)
            
        }
        else
        {
            SingleToneClass.shared.selectedBtn   = "Add Post"
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
            
            //homeVC.loginType = login
            
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
    }
}

extension ProfileController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print(postAllUserData.count)
//        print(userData.count )
        if (postAllUserData.count == userData.count)
        {
            return (postAllUserData.count )
        }
        else
        
        {
            return 0
        }
        
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath as IndexPath) as! HomeTableCell
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
        cell.userImage.clipsToBounds = true
        cell.commnentBtn.tag = indexPath.row
        cell.favBtn.tag = indexPath.row
        cell.commnentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        cell.postId = postAllUserData[indexPath.row].postId
        cell.postUserName = postAllUserData[indexPath.row].userName
        cell.postUserId = postAllUserData[indexPath.row].userId
        cell.getUserName = self.userNameLbl.text!
        cell.likeLbl.text = String( postAllUserData[indexPath.row].likes)
        cell.commentlbl.text = String( postAllUserData[indexPath.row].comments)
        
        if postAllUserData[indexPath.row].userId == userData[indexPath.row].userId
        {
             cell.userImage.sd_setImage(with: URL(string: userData[indexPath.row].userProfileImg as! String),placeholderImage: UIImage(named: " "))
        }
        
        if self.postAllUserData[indexPath.row].imgUrl == " "
        {
          cell.playBtn.isHidden = false
            cell.postImg.sd_setImage(with: URL(string: self.postAllUserData[indexPath.row].thumbleImage!), placeholderImage: UIImage(named: " "))
        }
        else
        {
            cell.playBtn.isHidden = true
            
           // cell.postImg.downloadImg(from: self.postAllUserData[indexPath.row].imgUrl!)
            cell.postImg.sd_setImage(with: URL(string: self.postAllUserData[indexPath.row].imgUrl!), placeholderImage: UIImage(named: " "))
            
            
            if(( (postAllUserData[indexPath.row].imageWidth) > 300) && (postAllUserData[indexPath.row].imageHeight) > 400)
            {
                cell.postImg.contentMode = .scaleToFill
                cell.backgroundColor = UIColor.white
            }
            else
            
            {
                cell.postImg.contentMode = .scaleAspectFit
                  cell.backgroundColor = UIColor.black
            }
            
            
            
        }
        
       cell.userName.text = userData[indexPath.row].userName!
        
        
        if (self.postAllUserData[indexPath.row].peopleWholike.count == 0)
        {
            cell.favBtn.isHidden = false
            cell.disLikeBtn.isHidden = true
        }
        
        else
        {
            for person in self.postAllUserData[indexPath.row].peopleWholike
            {
               
                if person == Auth.auth().currentUser?.uid
                {
                    cell.favBtn.isHidden = true
                    cell.disLikeBtn.isHidden = false
                    break
                }
                else
                {
                    cell.favBtn.isHidden = false
                    cell.disLikeBtn.isHidden = true
                    
                }
            }
        }
        
         cell.reportView.tag = indexPath.row
         cell.reportView.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
        
        return cell
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.postAllUserData[indexPath.row].videoUrl == " "
        {
            let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
            
            
            regVC.userName = postAllUserData[indexPath.row].userName
            regVC.imgurl = postAllUserData[indexPath.row].imgUrl
            regVC.postId = postAllUserData[indexPath.row].postId
            
            self.tabBarController?.navigationController?.pushViewController(regVC, animated: false)
        }
        else
        {
            self.videoURL = self.postAllUserData[indexPath.row].videoUrl
            
            playExternalVideo()
        }
        
        
        
    }
    
    @objc func reportAction(sender: UIButton){
        
      
        
        self.reportView.isHidden = false
        
        self.homeCollView.isUserInteractionEnabled = false
        
    }
    
   
    @objc func commentAction(sender: UIButton){
        
       // showAlertMessage(alertTitle: "Alert", alertMsg: "This part is under development")
        
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentController") as! CommentController

        commentVC.postId = postAllUserData[sender.tag].postId

        self.navigationController?.pushViewController(commentVC, animated: false)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ((self.view.frame.height) - 12.0)
        
    }
    
}

/*
 
 if (self.videonewURL == nil)
 {
 self.showAlertMessage(alertTitle: "Error", alertMsg: "Please upload any image or video to post..")
 }
 
 
 else
 {
 
 let feed = [
 "userId": uid,
 "pathToImage" : self.videonewURL?.absoluteString as Any,
 "postID" : key,
 "userName"      : Auth.auth().currentUser?.displayName ?? " "
 ] as [String :Any]
 
 let postFeed = ["\(key)" : feed]
 ref.child("userProfileData").updateChildValues(feed)
 // ref.child("posts").childByAutoId().setValue(feed)
 
 self.dismiss(animated: true, completion: nil)
 
 
 }
 
 
 })
 */
