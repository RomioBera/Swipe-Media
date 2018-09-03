//
//  HomeController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 07/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import AVKit
import AVFoundation
import MBProgressHUD


class HomeController: UIViewController {

    var loginType = ""
    var imageName = String()
    var imagePicker = UIImagePickerController()
    var uploadType = ""
    var videonewURL: NSURL?
    var videoURL = " "
    var postData = [PostData]()
    var commentData = [CommentsData]()
    var refHandel : UInt!
    var dataDic = NSDictionary()
    var cell = HomeCollCell()
    var texts = [Int:String]()
    var userId = NSMutableArray()
    var postId = NSMutableArray()
    var imgId = NSMutableArray()
     var userProfileData = [UserProfileData]()
    var newData = [PostArrayData]()
    var newReverseArray = NSArray()
    var newDictData = NSMutableDictionary()
    @IBOutlet var dummyImage: UIImageView!
    @IBOutlet var uploadImg: UIImageView!
    @IBOutlet var homeCollView: UICollectionView!
    @IBOutlet var aboutPostTxt: UITextView!

    var selectedIndex = NSInteger()
    var likeCount = " "
    
    var commntTxt = UITextView()
    var indexCount = NSInteger()
    
    @IBOutlet var feedTblView: UITableView!
    
   
    @IBOutlet var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


      
    }
    
    @IBAction func crossAction(_ sender: Any) {
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
       // self.navigationItem.setHidesBackButton(true, animated:true)
        
       // MBProgressHUD.showAdded(to: (self.view)!, animated: true)
        
        
        indexCount = 0
        self.postData.removeAll()
        self.userId.removeAllObjects()
        self.fetchPosts()
      // self.fetchProfileData()
    }
    
    func fetchPosts()
    {
       
        
        let ref = Database.database().reference()
        ref.child("newposts").queryLimited(toFirst: 10).queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
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
                                       userToShow.postId = value["postID"] as? String
                                        userToShow.userId = value["userId"] as? String
                                        userToShow.postDes = value["post_description"] as? String
                                        userToShow.imgUrl = value["pathToImage"] as? String
                                        userToShow.userName = value ["userName"] as? String
                                        userToShow.videoUrl = value ["pathToVideo"] as? String
                                        userToShow.likes = value ["likes"] as! Int
                                        // userToShow.profileImg = value["profileImage"] as? String
                                        
                                        if let people = value["peoplewhoLike"] as? [String: AnyObject]
                                        {
                                            for (_,person) in people
                                            {
                                                userToShow.peopleWholike.append(person as! String)
                                            }
                                        }
                                        self.postData.append(userToShow)
                                        self.fetchUserPostData(postId:(value["userId"] as? String)! )
                                     
                                        
                                    }
                                }
                
                
              // print(users)
               
                
            }
            
          // self.feedTblView.reloadData()
            
        })
 
      // ref.removeAllObservers()
    }
    
 
    func fetchUserPostData(postId: String)
    {
      
    print(postId)
       let ref = Database.database().reference().child("userProfileData").queryOrdered(byChild: "userId").queryEqual(toValue : postId)
       // let ref = Database.database().reference().child("userProfileData").queryEqual(toValue: postId, childKey: "userId")
        ref.observe(.value, with:{ (snapshot) in
            
         print(snapshot)
            
            if snapshot.childrenCount == 0
            {
//                self.userToShow.profileImg = " "
//                 self.postData.append(self.userToShow)
            }
                
            else
            {
                
                
                  let users = snapshot.value as! [String : AnyObject]
                //users.value["pathToImage"] as? String

                for (_,value) in users
                
                {
                     //self.userToShow.profileImg = value["pathToImage"] as? String
                     //self.postData.append(self.userToShow)
                  
                   // print(value["pathToImage"] as? String)
                    
                      self.userId.add(value["pathToImage"] as? String)
                    
//                    if (self.userId .contains(value["pathToImage"] as? String))
//                    {
//                        print("value already exits")
//                    }
//                    else
//
//                    {
//
//
//                       // self.imgId = self.userId.reversed() as! NSMutableArray
//
//
//                    }
                    
                    
                   // let para = ["uid": postId,"img":value["pathToImage"] as? String]
                    //self.newDictData.addEntries(from:para)
                   
                    //print(self.newDictData)
                    
                    print(self.userId)
                }
            
                
                
            
            
        }
        
           // self.userId.removeObject(at: 0)
            print(self.userId)
            DispatchQueue.main.async { [unowned self] in
               self.feedTblView.reloadData()
            }
            
    })
      // ref.removeAllObservers()
    }
    

//
    
    func fetchCommentsData(postId: String)
    {
       
        
        
        let ref = Database.database().reference().child("comments").queryOrdered(byChild: "postID").queryEqual(toValue : postId)
        
        ref.observe(.value, with:{ (snapshot) in
            for snap in snapshot.children {
              //  print((snap as! DataSnapshot))
                 let users = snapshot.value as! [String : AnyObject]
                
                print(users)
                let userToShow = CommentsData()
                
                self.commentData.removeAll()
                
                for (_,value) in users
                {
                    userToShow.comment = value["comment_description"] as? String
                    userToShow.userId = value["currentUserId"] as? String
                    userToShow.postId = value["postID"] as? String
                    
                    self.commentData.append(userToShow)

                }
                
            }
        })
        
        
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
extension HomeController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @objc  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if self.uploadType == "video"
        {
            let metaData = StorageMetadata()
            metaData.contentType = "video/.mp4"
           
            imagePicker.dismiss(animated: true, completion: nil)
            
        
            if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                // we selected a video
               /// print("Here's the file URL: ", videoURL)
                // Where we'll store the video:
                let storageReference = Storage.storage().reference().child("User/\(String(describing: Auth.auth().currentUser?.uid)).mp4")
                
                // Start the video storage process
               
                storageReference.putFile(from: videoURL as URL, metadata: nil, completion: { (metadata, error) in
                    if error == nil {
                       // print("Successful video upload")
                        
                        guard let metadata = metadata else{
                            
                           // print(error!)
                            
                            return
                            
                        }
                        
                        //print(metadata)
                        
                      //  let fullPath = metadata.path
                    //    print(fullPath)
                        let downloadURL = metadata.downloadURL()
                        self.videonewURL = downloadURL! as NSURL
                       // print(downloadURL ?? "0")
                        
                        
                        
                        
                    } else {
                        //print(error!)
                    }
                })
                
            }
            //Dismiss the controller after picking some media
            dismiss(animated: true, completion: nil)
            
        
        }
            else
            {
                
                
                if let image = info[UIImagePickerControllerEditedImage ] as? UIImage
                {
                    self.uploadImg.image = image
                }
               myImageUploadRequest()
                self.dismiss(animated: true, completion: nil)
        
        
       }
    }
    
        func myImageUploadRequest()
    {
       
        let imageData = UIImageJPEGRepresentation(self.uploadImg.image!, 0.9)
        print(imageData!)
        
        if(imageData==nil)  {
            
            return
            
        }
        
        let storage = Storage.storage()
        
        
        let metaData = StorageMetadata()
         metaData.contentType = "image/png"
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("images/\(String(describing: Auth.auth().currentUser?.uid)).png")
        
        _ = imageRef.putData(imageData!, metadata: nil, completion: { (metadata,error ) in
            
            guard let metadata = metadata else{
                
               // print(error!)
                
                return
                
            }
            
           // print(metadata)
            
           // let fullPath = metadata.path
          //  print(fullPath)
            let downloadURL = metadata.downloadURL()
            self.videonewURL = downloadURL! as NSURL
          //  print(downloadURL ?? "0")
              
        })
       
    }
}



extension UIImageView
{
    func downloadImg(from imgUrl :String)
    {
     
        let url = URLRequest(url : URL(string: imgUrl)!)
        
        let task = URLSession.shared.dataTask(with: url){
                (data,response,error)  in

                 if (error != nil)
                 {
                   // print(error!)
                    
                   // print("error")
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                    
                }
             }
       
        task.resume()
    }
   
}

extension HomeController : UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView) {
        
       
        
    }
}


extension HomeController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if (postData.count) > 0
        {
             //indexCount = postData.count - 1
        }
       
       // print(self.postData.count)
         return self.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath as IndexPath) as! HomeTableCell
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
        cell.userImage.clipsToBounds = true
        cell.postId = postData[indexPath.row].postId
        cell.likeLbl.text = String( postData[indexPath.row].likes)
        
        if self.postData[indexPath.row].imgUrl == " "
        {
            cell.playBtn.isHidden = false
            let asset: AVAsset = AVAsset(url: URL(string: self.postData[indexPath.row].videoUrl)!)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
                cell.postImg.image = UIImage(cgImage: thumbnailImage)
            } catch let error {
                print(error)
            }
            
        }
        else
        {
            cell.playBtn.isHidden = true
            
            cell.postImg.downloadImg(from: self.postData[indexPath.row].imgUrl!)
        }
        
        if postData[indexPath.row].userName == " "
        {
            cell.userName.text = " "
        }
        else
        {
            cell.userName.text = postData [indexPath.row].userName!
        }
        cell.userImage.downloadImg(from: userId[indexPath.row] as! String)
        if (userId.count > 0)
        {
            if (self.userId[indexPath.row] as! String  == " ")
            {
                cell.userImage.image  = UIImage(named: "Profile Icon")
                
            }
            else
            {
              //  cell.userImage.downloadImg(from: userId[indexCount - indexPath.row] as! String)
               
            }
        }
        
        if postData[indexPath.row].likes == 0
        {
            cell.favBtn.isHidden = false
            cell.disLikeBtn.isHidden = true
        }
        else
        
        {
            cell.favBtn.isHidden = true
            cell.disLikeBtn.isHidden = false
        }
        
        for person in self.postData[indexPath.row].peopleWholike
        {
            if person == Auth.auth().currentUser?.uid
            {
                cell.favBtn.isHidden = true
                cell.disLikeBtn.isHidden = false
                break
            }
        }
        
       // cell.postImg.downloadImg(from: self.postData[indexPath.row].imgUrl!)
        cell.commnentBtn.tag = indexPath.row
        cell.favBtn.tag = indexPath.row
        //cell.favBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        cell.commnentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.postData[indexPath.row].videoUrl == " "
        {
            let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
            
            
             regVC.userName = postData[indexPath.row].userName
             regVC.imgurl = postData[indexPath.row].imgUrl
             regVC.postId = postData[indexPath.row].postId
            
            self.tabBarController?.navigationController?.pushViewController(regVC, animated: false)
        }
        else
        {
            self.videoURL = self.postData[indexPath.row].videoUrl
            
            playExternalVideo()
        }
        
       
        
    }
    
    @objc func likeAction(sender: UIButton){
        
       /*
        let ref = Database.database().reference()
        let keyToPost = ref.child("newposts").childByAutoId().key
        selectedIndex = sender.tag
        
        ref.child("newposts").child(postData[sender.tag].postId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            
          if  let post = snapshot.value as? [String : AnyObject]
          {
            let updateLikes:[String : Any] = ["peoplewhoLike/\(keyToPost)":Auth.auth().currentUser?.uid]
            
            ref.child("newposts").child(self.postData[sender.tag].postId).updateChildValues(updateLikes,withCompletionBlock : {(error,reff) in

                if error == nil
                
                {
                    ref.child("newposts").child(self.postData[sender.tag].postId).observeSingleEvent(of: .value, with:{
                       
                        
                        (snap) in
                        
                        if let properties = snap.value as? [String: Any]
                        {
                            
                           if let likes = properties["peoplewhoLike"] as? [String : Any]
                            
                           {
                            let count = likes.count
                            self.likeCount = String(likes.count)
                            print(count)
                            let update = ["likes" : count]
                            ref.child("newposts").child(self.postData[sender.tag].postId).updateChildValues(update)
                             self.feedTblView.reloadData()
                            }
                        }
                    }
                    
                    
                    )
                }
                
                
            }
                                                                                       
                                                                                       
            )}
            
            
           
            
        })*/
    }
        
        
        
    
    @objc func commentAction(sender: UIButton){
        
        showAlertMessage(alertTitle: "Alert", alertMsg: "This part is under development")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ((self.view.frame.height) - 12.0)
        
    }
    
}

/*
 let postImagesRef = postsRef.child(postId).child("pImages");
 postImagesRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
 var counter = 0
 for item in snapshot.children{
 imagesRef.child(item.key).observeSingleEventOfType(.Value, withBlock: { (snap) in
 let image = Image(snapshot: snap)
 print(image)
 imgArray.append(image)
 counter = counter + 1
 if (counter == snapshot.childrenCount) {
 completion(result:imgArray, error:nil)
 }
 })
 }
 })
 
 *//*
 let refnew = Database.database().reference().child("posts").queryOrdered(byChild: postId)
 
 refnew.observe(.value, with:{ (snapshot) in
 var counter = 0
 for item in snapshot.children{
 imagesRef.child((item as AnyObject).key).observeSingleEvent(of: .value, with: { (snap) in
 let image = UIImage()
 print(image)
 self.imgArray.append(image)
 counter = counter + 1
 if (counter == snapshot.childrenCount) {
 
 }
 })
 }
 })
 */
/*
@objc func commentBtnAction(_ sender : UIButton)
{
    
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    // let key  = ref.child("comments").child("postId").childByAutoId().key
    // let cell =  HomeCollCell()HomeCollCell
    //    let cell: HomeCollCell = (self.homeCollView.cellForItem(at:) as? HomeCollCell)!
    let feed = [
        "currentUserId": uid,
        "postID" :  self.postData[sender.tag].postId,
        "posterUserId" : self.postData[sender.tag].userId,
        "comment_description" :  "hi hi hi post post 450"
        ] as [String :Any]
    
    // let postFeed = ["\(key)" : feed]
    ref.child("comments").childByAutoId().setValue(feed)
    
}
 
 extension HomeController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
 {
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return self.postData.count
 }
 
 // make a cell for each cell index path
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
 // get a reference to our storyboard cell
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath as IndexPath) as! HomeCollCell
 
 if self.postData[indexPath.row].imgUrl == " "
 {
 cell.playBtn.isHidden = false
 let asset: AVAsset = AVAsset(url: URL(string: self.postData[indexPath.row].videoUrl)!)
 let imageGenerator = AVAssetImageGenerator(asset: asset)
 
 do {
 let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
 cell.postImg.image = UIImage(cgImage: thumbnailImage)
 } catch let error {
 print(error)
 }
 
 }
 else
 {
 cell.playBtn.isHidden = true
 
 cell.postImg.downloadImg(from: self.postData[indexPath.row].imgUrl!)
 }
 
 return cell
 }
 // MARK: - UICollectionViewDelegate protocol
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 // handle tap events
 print("You selected cell #\(indexPath.item)!")
 
 if self.postData[indexPath.row].videoUrl == " "
 {
 let regVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
 
 
 regVC.userName = postData[indexPath.row].userName
 regVC.imgurl = postData[indexPath.row].imgUrl
 
 
 self.tabBarController?.navigationController?.pushViewController(regVC, animated: false)
 }
 else
 {
 self.videoURL = self.postData[indexPath.row].videoUrl
 
 playExternalVideo()
 }
 
 
 
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 return CGSize(width: (self.view.frame.width - 20)/3, height: (self.view.frame.width - 20)/3)
 }
 func collectionView(_ collectionView: UICollectionView,
 layout collectionViewLayout: UICollectionViewLayout,
 insetForSectionAt section: Int) -> UIEdgeInsets {
 return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
 }
 
 
 
 }
 
 
 /*
 
 let ref = Database.database().reference()
 ref.child("userProfileData").queryOrderedByKey().observeSingleEvent(of: .value, with: {
 
 (snapshot) in
 
 print(snapshot)
 
 if snapshot.childrenCount == 0
 {
 
 self.feedTblView.reloadData()
 return
 }
 let users = snapshot.value as! [String : AnyObject]
 
 //self.postData.removeAll()
 
 for (_,value) in users
 {
 if let uid = value["userId"] as? String
 {
 
 print(uid)
 print(postId)
 
 
 if uid == postId
 {
 //
 //                                let userToShow = PostData()
 //
 //                                userToShow.postId = value["postID"] as? String
 //                                userToShow.userId = value["userId"] as? String
 //                                userToShow.postDes = value["post_description"] as? String
 //                                userToShow.imgUrl = value["pathToImage"] as? String
 //                                userToShow.userName = value ["userName"] as? String
 //                                userToShow.videoUrl = value ["pathToVideo"] as? String
 //
 
 //    self.postId.add(value["pathToImage"] as? String ?? " ")
 
 
 
 }
 
 
 }
 
 
 print(users)
 
 
 }
 
 self.feedTblView.reloadData()
 
 })
 */
 //    func fetchProfileData(){
 //
 //        let ref = Database.database().reference()
 //        ref.child("userProfileData").queryOrderedByKey().observeSingleEvent(of: .value, with: {
 //
 //            (snapshot) in
 //
 //            print(snapshot)
 //
 //            if snapshot.childrenCount == 0
 //            {
 //                return
 //            }
 //            let users = snapshot.value as! [String : AnyObject]
 //
 //            self.postData.removeAll()
 //
 //            for (_,value) in users
 //            {
 //                if let uid = value["userId"] as? String
 //                {
 //                    if uid != Auth.auth().currentUser?.uid
 //                    {
 //
 //                        let userToShow = UserProfileData()
 //                        userToShow.getPostId = value["postID"] as? String
 //                        userToShow.getUserId = value["userId"] as? String
 //                        userToShow.getImagePath = value["pathToImage"] as? String
 //                        self.userProfileData.append(userToShow)
 //                    }
 //                }
 //
 //
 //                print(users)
 //
 //            }
 //
 //            MBProgressHUD.hide(for: (self.view)!, animated: true)
 //        })
 //
 //
 //    }
 /*
 let ref = Database.database().reference()
 
 //FIRDatabase.database().reference().child("thoughts").queryOrdered(byChild: "createdAt").queryEqual(toValue : "Today")
 ref.child("comments").queryOrderedByKey().observeSingleEvent(of: .value, with: {
 
 (snapshot) in
 
 print(snapshot)
 
 if snapshot.childrenCount == 0
 {
 return
 }
 let users = snapshot.value as! [String : AnyObject]
 
 for (_,value) in users
 {
 let userToShow = CommentsData()
 
 userToShow.comment = value["comment_description"] as? String
 userToShow.userId = value["currentUserId"] as? String
 userToShow.postId = value["postID"] as? String
 //                userToShow.postDes = value["post_description"] as? String
 //                userToShow.imgUrl = value["pathToImage"] as? String
 self.commentData.append(userToShow)
 self.userId.add(userToShow.userId)
 self.postId.add(userToShow.postId)
 print(self.commentData)
 }
 
 // self.commentData.removeAll()
 self.homeCollView.reloadData()
 })
 
 */
 */
