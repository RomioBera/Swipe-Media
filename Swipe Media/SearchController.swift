//
//  SearchController.swift
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


class SearchController: UIViewController {

    @IBOutlet var homeScreen: UIView!
    @IBOutlet var searchTblview: UITableView!
    var textField = UITextField()
    var homeVC: HomeController! = nil
    var tabVC : TabButtonController! = nil
    var searchData = [UserProfileData]()
    
    @IBAction func btn(_ sender: Any) {
        
        print("ghhjhggg")
        homeScreen.removeFromSuperview()
        
    }
    
    
    @IBAction func secBtn(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 50.0))
        customView.backgroundColor = UIColor.clear
        
        let button = UIButton.init(type: .custom)
        // button.setBackgroundImage(UIImage(named: "Search Icon"), for: .normal)
        button.setImage(UIImage(named: "Search Icon"), for: .normal)
        button.frame = CGRect(x: 270.0, y: 5.0, width: 40.0, height: 30.0)
        button.addTarget(self, action: #selector(menuOpen), for: .touchUpInside)
        customView.addSubview(button)
        
        textField = UITextField(frame: CGRect(x: 60, y: 0.0, width: 200.0, height: 40.0))
        textField.textAlignment = NSTextAlignment.left
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: (textField.font?.fontName)!, size: 15)
        textField.placeholder = "search "
        
        
        
        customView.addSubview(textField)
        
        
//        let button2 = UIButton.init(type: .custom)
//        button2.frame = CGRect(x: 265.0, y: 5.0, width: 60.0, height: 30.0)
//        button2.setTitle("search", for: .normal)
//
//        button2.addTarget(self, action: #selector(menuOpen), for: .touchUpInside)
//        customView.addSubview(button2)
//
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.rightBarButtonItem = leftButton
        
        self.backBtn()
        self.searchTblview.isHidden = true
        
    }

    @objc func  menuOpen()
    {
        
        
        let ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "userName").queryStarting(atValue: textField.text).queryEnding(atValue: textField.text! + "\u{f8ff}").observe(.value, with: { snapshot in
            
            
            print(snapshot)
            
            if snapshot.childrenCount == 0
            {
                self.showAlertMessage(alertTitle: "Alert", alertMsg: "Does not find any matching profile")
                return
            }
            
            
            let users = snapshot.value as! [String : AnyObject]
            
            for (_,value) in users
            {
                
                let userToShow = UserProfileData()
                userToShow.getUserName = value["userName"] as? String
                userToShow.getImagePath = value["profilePic"] as? String
                userToShow.getUserId = value["userId"] as? String
              //  print(value["userName"] as? String)
                self.searchData.append(userToShow)
            }
            
            self.searchTblview.isHidden = false
            self.searchTblview.reloadData()
            
        })
        
        
        
    }
    

}
extension SearchController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
     return  searchData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath as IndexPath) as! SearchCell
        
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width / 2
        cell.profileImg.clipsToBounds = true
       
        cell.userName.text = searchData[indexPath.row].getUserName
     
        cell.profileImg.sd_setImage(with: URL(string: searchData[indexPath.row].getImagePath as! String),placeholderImage: UIImage(named: "Profile Icon"))
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SingleToneClass.shared.selectedBtn   = "Add Post"
        
        print(searchData[indexPath.row].getUserId)
        SingleToneClass.shared.selectedUser   = searchData[indexPath.row].getUserId
        
      self.navigationController?.popViewController(animated: true)
        
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
        
    }
    
}

