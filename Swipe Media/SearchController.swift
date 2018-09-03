//
//  SearchController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 20/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit



class SearchController: UIViewController {

    @IBOutlet var homeScreen: UIView!
    var homeVC: HomeController! = nil
    var tabVC : TabButtonController! = nil
    @IBAction func btn(_ sender: Any) {
        
        print("ghhjhggg")
        homeScreen.removeFromSuperview()
        
    }
    
    
    @IBAction func secBtn(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       // self.homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as? HomeController
        tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabButtonController") as? TabButtonController
      //  tabVC.btnView.isHidden = true
        homeScreen.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(self.view.frame.size.height) + 60)
        
        self.view?.addSubview(homeScreen)
        
    }


}
