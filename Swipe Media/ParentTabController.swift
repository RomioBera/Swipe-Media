//
//  ParentTabController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 20/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ParentTabController: UITabBarController ,UITabBarControllerDelegate,UIGestureRecognizerDelegate,sliderIndexDelegate,tabbarIndexDelegate {
   
    func getTabbarIndex(index: NSInteger) {
    
        if (index == 1)
        {
           // self.
          //   setAddPostNav()
            // self.selectedIndex = 1
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPostController") as! AddPostController
            
            //homeVC.loginType = login
            
            self.navigationController?.pushViewController(homeVC, animated: false)
            
           
        }
        else if (index == 2)
        
        {
            self.selectedIndex = 0
            
            setSearchNav()
          
        }
        else if (index == 0)
        {
            self.selectedIndex = 0
            
            setDefaultNav()
            
        }
        else
        {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
            
            //homeVC.loginType = login
            
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
    }
    
    @objc func  menuOpen()
    {
        //self.navigationController?.popViewController(animated: true)
        
        print("fghfgh")
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
    func getSliderIndex(index: NSInteger) {
        
        if (index == 1)
        {
            setProfileNav()
           self.selectedIndex = 1
        
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
    
    func viewButtonClicked(isClick: String) {
        
        
    }
    
    var sliderVC: SliderController! = nil
    var tabButtonVC : TabButtonController! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.red
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        
    //   setDefaultNav()
        

//        let image2 = UIImage(named: "log-out.png")
//        let buttonFrame2 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
//        let button2 = UIButton(frame: buttonFrame2)
//        button2.addTarget(self, action: #selector(self.logoutAction), for: .touchUpInside)
//        // button.setImage(image, for: .normal)
//        button2.setBackgroundImage(image2, for: .normal)
//        let item2 = UIBarButtonItem(customView: button2)
//        self.navigationItem.rightBarButtonItem = item2
        
        sliderVC = self.storyboard?.instantiateViewController(withIdentifier: "SliderController") as? SliderController
        sliderVC.view.frame = CGRect(x: CGFloat(-250), y: CGFloat(64), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height))
        
       
        
        self.view?.addSubview(sliderVC.view)
        sliderVC.view.isHidden = true;
        sliderVC.sliderDelegate=self
         self.delegate = self
        
//         tabButtonVC = self.storyboard?.instantiateViewController(withIdentifier: "TabButtonController") as? TabButtonController
//        tabButtonVC.view.frame = CGRect(x: CGFloat(0), y: CGFloat((self.view.frame.size.height) - 60 ), width: CGFloat((self.view.frame.size.width)), height: CGFloat(60))
//
//     // tabButtonVC.btnView.isHidden = true
//        tabButtonVC.btnView.backgroundColor = UIColor.clear
//        self.view?.addSubview(tabButtonVC.view)
//       tabButtonVC.tabbarDelegate = self
        // self.tabBar.isHidden = false
        //self.tabBarController?.tabBar.items![0].image = UIImage(named: "your image name")
        // items![0] index of your tab bar item.items![0] means tabbar first item
        // self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "your image name")
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
    }
    
    func setAddPostNav()
    {
        let image1 = UIImage(named: "Back Icon")
        let buttonFrame1 = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let button1 = UIButton(frame: buttonFrame1)
       // button1.addTarget(self, action: #selector(self.addPostButtonAction), for: .touchUpInside)
        button1.setImage(image1, for: .normal)
        let item1 = UIBarButtonItem(customView: button1)
        self.navigationItem.leftBarButtonItem = item1
    }
    
//    @objc func addPostButtonAction()
//    {
//         //SingleToneClass.shared.selectedBtn   = " "
//         //setDefaultNav()
//
//
//    }
    
    
    
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
        
        
        
//        let label = UILabel(frame: CGRect(x: 60, y: 0.0, width: 350.0, height: 40.0))
//        label.text = "title"
//        label.textColor = UIColor.darkGray
//        // label.textAlignment = NSTextAlignment.right
//        label.textAlignment = NSTextAlignment.left
//        label.backgroundColor = UIColor.clear
//        label.font = UIFont(name: label.font.fontName, size: 30)
//        customView.addSubview(label)
        
        let textField = UITextField(frame: CGRect(x: 60, y: 0.0, width: 200.0, height: 40.0))
        
        textField.textAlignment = NSTextAlignment.left
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: (textField.font?.fontName)!, size: 15)
        textField.placeholder = "search "
        
        customView.addSubview(textField)
        
        
        let button2 = UIButton.init(type: .custom)
        // button.setBackgroundImage(UIImage(named: "Search Icon"), for: .normal)
        // button.setImage(UIImage(named: "Search Icon"), for: .normal)
        button2.frame = CGRect(x: 265.0, y: 5.0, width: 60.0, height: 30.0)
        button2.setTitle("search", for: .normal)
        
        button2.addTarget(self, action: #selector(menuOpen), for: .touchUpInside)
        customView.addSubview(button2)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
        
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
            
//            if UIDevice.Display.typeIsLike == UIDevice.DisplayType.ipad
//            {
//
//                self.sliderVC.view.frame = CGRect(x: CGFloat(-350), y: CGFloat(64), width: CGFloat(350), height: (self.view.frame.height))
//
//            }
//            else
//            {
//
//            }
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
   

}
