//
//  TabButtonController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 20/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit

protocol tabbarIndexDelegate {
    func getTabbarIndex(index: NSInteger) -> Void
    
}

protocol btnIndexDelegate {
    func getBtnIndex(index: NSInteger) -> Void
    
}





class TabButtonController: UIViewController {

    var tabbarDelegate: tabbarIndexDelegate?
    var btnDelegate : btnIndexDelegate?
    var clickBtn = ""
    
    @IBOutlet var btnView: UIView!
    
    
    @IBOutlet var homeBtn: UIButton!
    
    @IBOutlet var addBtn: UIButton!
    
    @IBOutlet var searchBtn: UIButton!
    
    @IBOutlet var videoLbl: UILabel!
    
    @IBOutlet var galleryLbl: UILabel!
    
    @IBOutlet var addContractBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func searchBtnAction(_ sender: Any) {
        
        print("Search")
      // self.btnView.isHidden = false
        
        self.videoLbl.isHidden = true
        self.galleryLbl.isHidden = true
        self.addBtn.isHidden = false
        self.homeBtn.setImage(UIImage(named: "Home Icon"), for: .normal)
        self.addBtn.setImage(UIImage(named: "Add Post Icon"), for: .normal)
        self.searchBtn.setImage(UIImage(named: "TabSearch Icon"), for: .normal)
        
        if  SingleToneClass.shared.selectedBtn == "Add Post"
        {
            self.btnDelegate?.getBtnIndex(index: 2)
        }
        else
        {
            self.tabbarDelegate?.getTabbarIndex(index: 2)
            
            self.videoLbl.isHidden = true
            self.galleryLbl.isHidden = true
            self.addBtn.isHidden = false
            self.homeBtn.setImage(UIImage(named: "Home Icon"), for: .normal)
            self.addBtn.setImage(UIImage(named: "Add Post Icon"), for: .normal)
            self.searchBtn.setImage(UIImage(named: "TabSearch Icon"), for: .normal)
            
        }
        
        
    }
    
    
    @IBAction func addContractBtnAction(_ sender: Any) {
        
         self.tabbarDelegate?.getTabbarIndex(index: 3)
        
    }
    
    //("Add Post")
    @IBAction func addPostBtnAction(_ sender: Any) {
        
//
//        print("Add Post")
//
//      SingleToneClass.shared.selectedBtn   = "Add Post"
//
//     //  self.btnView.isHidden = true
//
//    self.videoLbl.isHidden = false
//        self.galleryLbl.isHidden = false
//        self.addBtn.isHidden = true
//        self.homeBtn.setImage(UIImage(named: "Attach Icon"), for: .normal)
//        //self.addBtn.setImage(UIImage(named: "Add Post"), for: .normal)
//        self.searchBtn.setImage(UIImage(named: "Video Icon"), for: .normal)
//
         self.tabbarDelegate?.getTabbarIndex(index: 1)
//
//
       
       
        
        
        
    }
    
    @IBAction func homeBtnAction(_ sender: Any) {
        
        print("Home")
      // self.btnView.isHidden = false
       
        if  SingleToneClass.shared.selectedBtn == "Add Post"
        {
            self.btnDelegate?.getBtnIndex(index: 0)
        }
        else
        {
            self.tabbarDelegate?.getTabbarIndex(index: 0)
            
            self.videoLbl.isHidden = true
            self.galleryLbl.isHidden = true
            self.addBtn.isHidden = false
            self.homeBtn.setImage(UIImage(named: "Home Icon"), for: .normal)
            self.addBtn.setImage(UIImage(named: "Add Post Icon"), for: .normal)
            self.searchBtn.setImage(UIImage(named: "TabSearch Icon"), for: .normal)
            
            
        }
        
    }
    
    
}
