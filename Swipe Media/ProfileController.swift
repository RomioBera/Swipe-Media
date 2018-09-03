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
    @IBOutlet var postTblView: UIView!
    
    var videoURL = " "
    var profileImgUrl = " "
    var profilePicArray = NSMutableArray()
    var postData = [PostData]()
    var postAllUserData = [PostData]()
    var userProfileData = [UserProfileData]()
    var userData = [UserData]()
    var loginType = ""
    var imageName = String()
    var imagePicker = UIImagePickerController()
    var uploadType = ""
    var videonewURL: NSURL?
    var sliderVC: SliderController! = nil
    var tabButtonVC : TabButtonController! = nil
    var ispostLiked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "loginType") as! String == "emailpassword"
        {
            if UserDefaults.standard.object(forKey: "userName") == nil
            {
                self.title = "unknown"
            }
            else
            {
                self.title = UserDefaults.standard.value(forKey: "userName") as? String
            }
           
        }
       else
        {
            self.title = Auth.auth().currentUser?.displayName
        }
    
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
        self.profileImg.clipsToBounds = true
        
       postTblView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        
        self.view?.addSubview(postTblView)
        self.view.isHidden = false;
        
        
    }
    // cross btn action: - Mark
    @IBAction func btnAction(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.view.isHidden = false
        postTblView.removeFromSuperview()
        
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
        
        print(SingleToneClass.shared.selectedBtn)
        
        if SingleToneClass.shared.selectedBtn  == " "
        {
            self.navigationController?.isNavigationBarHidden = true
            
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
        }
        
       // MBProgressHUD.showAdded(to: self.view, animated: true)
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
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        //.queryOrderedByKey()
        ref.child("userProfileData").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
          /*
            if snapshot.childrenCount == 0
            {
                return
            }
            let users = snapshot.value as! [String : AnyObject]
            
            print(users)
            let userToShow = UserProfileData()
            userToShow.getUserName = users["userName"] as? String
             userToShow.getImagePath = users["profilePic"] as? String
            self.userProfileData.append(userToShow)
            // self.userNameLbl.text = userToShow.getUserName
            
            
            
            
          //  self.userProfileData.append(<#T##newElement: UserProfileData##UserProfileData#>)
            
            //self.postData.removeAll()
            
            */
            let users = snapshot.value as! [String : AnyObject]
            
            
            for (_,value) in users
            {
            

            if let uid = value["userId"] as? String
            {
                if uid == Auth.auth().currentUser?.uid
                {

                    let userToShow = UserProfileData()
                    userToShow.getUserId = value["userId"] as? String
                    userToShow.getImagePath = value["pathToImage"] as? String
                    self.userProfileData.append(userToShow)
                    
                    self.profileImg.sd_setImage(with: URL(string: (value["pathToImage"] as? String)!))
                   // print(value["userName"]as? String)
                }
            }
            
            MBProgressHUD.hide(for: (self.view)!, animated: true)
        }
        })
        
        
        
        
    }
    
    
    // Data fetch for collectionview : - Personal Post Data Fetch
    func fetchUserProfilePosts()
    {
        let ref = Database.database().reference()
        ref.child("newposts").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            //print(snapshot)
            
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
                    if uid == Auth.auth().currentUser?.uid
                    {
                        
                       // print(value ["pathToVideo"] as? String)
                        let userToShow = PostData()
                        userToShow.postId = value["postID"] as? String
                        userToShow.userId = value["userId"] as? String
                        userToShow.postDes = value["post_description"] as? String
                        userToShow.imgUrl = value["pathToImage"] as? String
                        userToShow.userName = value ["userName"] as? String
                        userToShow.videoUrl = value ["pathToVideo"] as? String
                        userToShow.likes = value ["likes"] as? Int
                         userToShow.comments = value ["comments"] as? Int
                        self.postData.append(userToShow)
                    }
                }
                
                
                print(users)
                
            }
            
            self.profileCollView.reloadData()
            
        })
        
        
    }
    
    
    // value fetch for Home Screen  All user Post Data in Tableview:- Mark
    
    func fetchAllUserPost()
    {
        let ref = Database.database().reference()
        ref.child("newposts").queryLimited(toFirst: 10).queryOrderedByKey().observeSingleEvent(of: .value, with: {
                
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
                             // userToShow.profileImg = value["profileImage"] as? String
                            
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
    
    print(userId)
  //  let ref = Database.database().reference().child("userProfileData").queryOrdered(byChild: "userId").queryEqual(toValue : postId)
    let ref = Database.database().reference().child("userProfileData").child(userId)

    ref.observe(.value, with:{ (snapshot) in
        
        print(snapshot)
        
        if snapshot.childrenCount == 0
        {
            //self.profilePicArray.add(" ")
            let uData = UserData()
            uData.userName = " "
            uData.userProfileImg = " "
            uData.userId = userId
            self.userData.append(uData)
        }
            
        else
        {
            
            
            let users = snapshot.value as! [String : AnyObject]

            
            let profileImg = users["pathToImage"] as? String
            
            let uData = UserData()
            
            uData.userName = users["userName"] as? String
            uData.userProfileImg = users["pathToImage"] as? String
            uData.userId = users["userId"] as? String
            
        self.userData.append(uData)
            
            print(profileImg!)
            
        }
       
      //  print(self.profilePicArray)
        DispatchQueue.main.async { [unowned self] in
            self.homeScreenTblview.reloadData()
        }
        
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
        
        if UserDefaults.standard.value(forKey: "loginType") as! String == "emailpassword"
        {
            if UserDefaults.standard.object(forKey: "userName") == nil
            {
                self.title = "unknown"
            }
            else
            {
                self.title = UserDefaults.standard.value(forKey: "userName") as? String
            }
            
        }
        else
        {
            self.title = Auth.auth().currentUser?.displayName
        }
        
    }
    
    func setAddPostNav()
    {
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
       SingleToneClass.shared.selectedBtn   = "Add Post"
        
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
        
        let textField = UITextField(frame: CGRect(x: 60, y: 0.0, width: 200.0, height: 40.0))
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
}


extension ProfileController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.postData.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollCell", for: indexPath as IndexPath) as! ProfileCollCell
        
        if (self.postData[indexPath.row].imgUrl! == " ")
        {
            cell.uploadImg.image = UIImage(named: "Profile Icon")
            
        }
        else
        {
            
            print(self.postData[indexPath.row].imgUrl!)
            //cell.uploadImg.downloadImg(from: self.postData[indexPath.row].imgUrl!)
            cell.uploadImg.sd_setImage(with: URL(string: self.self.postData[indexPath.row].imgUrl!), placeholderImage: UIImage(named: " "))
        }
      print(self.postData[indexPath.row].videoUrl)  
        
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        
        for person in self.postAllUserData[indexPath.row].peopleWholike
        {
            print(person)
            print(Auth.auth().currentUser?.uid)
            if person == Auth.auth().currentUser?.uid
            {
               ispostLiked = true
                break
            }
            else
            {
                
                
            }
        }
        
        SingleToneClass.shared.selectedBtn = "Photo"
        
        if self.postData[indexPath.row].videoUrl == " "
        {
            
            
            
            let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
            
            
            regVC.userName = postData[indexPath.row].userName
            regVC.imgurl = postData[indexPath.row].imgUrl
            regVC.isPostLikeed = ispostLiked
            regVC.postId = postData[indexPath.row].postId
            regVC.profileImgUrl = profileImgUrl
            regVC.likeCount = String(postData[indexPath.row].likes)
            regVC.commentCount = String(postData[indexPath.row].comments)
            self.navigationController?.pushViewController(regVC, animated: false)
        }
        else
        {
            self.videoURL = self.postData[indexPath.row].videoUrl
            
            playExternalVideo()
        }
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  return CGSize(width: ((self.view.frame.width / 3)-20), height: 100)
        
        return CGSize(width: ((self.view.frame.width / 3)), height: ((self.view.frame.width / 3)))
        
    }

}


extension ProfileController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
            self.videonewURL = downloadURL! as NSURL
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
           
            
            if (self.videonewURL == nil)
            {
                self.showAlertMessage(alertTitle: "Error", alertMsg: "Please upload any image or video to post..")
            }
            else
            {
                let key  = ref.child("userProfileData").childByAutoId().key
                let refnew = Database.database().reference().child("userProfileData").queryOrdered(byChild: uid)
                
                refnew.observe(.value, with:{ (snapshot) in
                    
                    let feed = [
                        "userId": uid,
                        "pathToImage" : self.videonewURL?.absoluteString as Any,
                        "postID" : key,
                        "userName"      : Auth.auth().currentUser?.displayName ?? " "
                        ] as [String :Any]
                    
                    
                    if snapshot.childrenCount == 0
                    {
                        
                        let postFeed = ["\(key)" : feed]
                        ref.child("userProfileData").setValue(postFeed)
                    }
                        
                    else
                    {
                        let key  = ref.child(uid).key
                        let postFeed = ["\(key)" : feed]
                        ref.child("userProfileData").updateChildValues(postFeed)
                    }
                    
                })
            }
            
          
    })
}
}
extension ProfileController : sliderIndexDelegate

{
    func viewButtonClicked(isClick: String) {
        
    }
    
    @objc func  menuOpen()
    {
        //self.navigationController?.popViewController(animated: true)
        
        print("fghfgh")
    }
    
   
    func getSliderIndex(index: NSInteger) {
        
        SingleToneClass.shared.selectedBtn = "Menu Btn Clicked"
        
//        if index == 0
//        {
//            let addContractVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
//
//            self.navigationController?.pushViewController(addContractVC, animated: true)
//
//
//        }
        
            if (index == 1)
        {
            setProfileNav()
           
            slideViewHideAnimation()
        }
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
            
            self.navigationController?.pushViewController(homeVC, animated: false)
            
            
        }
        else if (index == 2)
            
        {
            SingleToneClass.shared.selectedBtn   = " Search"
            setSearchNav()
            
        }
        else if (index == 0)
        {
            SingleToneClass.shared.selectedBtn   = " "
            self.navigationController?.isNavigationBarHidden = true
            tabButtonVC.btnView.isHidden = true
            postTblView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
            
            
            
            self.view?.addSubview(postTblView)
            
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
        
        print(postAllUserData.count)
        print(userData.count )
        return (postAllUserData.count )
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath as IndexPath) as! HomeTableCell
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
        cell.userImage.clipsToBounds = true

        cell.commnentBtn.tag = indexPath.row
        cell.favBtn.tag = indexPath.row
        cell.commnentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        
        cell.postId = postAllUserData[indexPath.row].postId
        cell.likeLbl.text = String( postAllUserData[indexPath.row].likes)
         cell.commentlbl.text = String( postAllUserData[indexPath.row].comments)
        
        if postAllUserData[indexPath.row].userId == userData[indexPath.row].userId
        {
             cell.userImage.sd_setImage(with: URL(string: userData[indexPath.row].userProfileImg as! String),placeholderImage: UIImage(named: " "))
        }
        
        
        if self.postAllUserData[indexPath.row].imgUrl == " "
        {
           
            cell.playBtn.isHidden = false
            let asset: AVAsset = AVAsset(url: URL(string: self.postAllUserData[indexPath.row].videoUrl)!)
            let imageGenerator = AVAssetImageGenerator(asset: asset)

            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
                
                print(thumbnailImage)
                DispatchQueue.main.async(execute: {
                    // assign your image to UIImageView
                    
                   cell.postImg.image = UIImage(cgImage: thumbnailImage)


                })

            } catch let error {
                print(error)
                
            }
            
        }
        else
        {
            cell.playBtn.isHidden = true
            
           // cell.postImg.downloadImg(from: self.postAllUserData[indexPath.row].imgUrl!)
            cell.postImg.sd_setImage(with: URL(string: self.postAllUserData[indexPath.row].imgUrl!), placeholderImage: UIImage(named: " "))
        }
        
        if postAllUserData[indexPath.row].userName == " "
        {
            cell.userName.text = " "
        }
        else
        {
            cell.userName.text = postAllUserData [indexPath.row].userName!
        }
        
        for person in self.postAllUserData[indexPath.row].peopleWholike
        {
            //print(person)
            //print(Auth.auth().currentUser?.uid)
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
