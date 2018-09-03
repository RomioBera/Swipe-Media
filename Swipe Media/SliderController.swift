//
//  SliderController.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 20/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit

protocol sliderIndexDelegate {
    func getSliderIndex(index: NSInteger) -> Void
    func viewButtonClicked(isClick: String) -> Void
}

class SliderController: UIViewController {

   
    @IBOutlet var sliderTblview: UITableView!
    
    var sliderDelegate: sliderIndexDelegate?
    
    var sectionArray = ["Follow","Privacy and Security ","About",]
      var iconArray = ["Follow Icon","Privacy Icon","About Icon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func logoutBtnAction(_ sender: Any) {
        
        self.sliderDelegate?.getSliderIndex(index: 4)
    }
    
}
extension SliderController : UITableViewDataSource,UITableViewDelegate
    
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return sectionArray.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = sliderTblview.dequeueReusableCell( withIdentifier: "SliderCell", for: indexPath) as! SliderCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        self.sliderTblview.separatorColor = UIColor.clear
        cell.sliderLbl.text = sectionArray[indexPath.row]
       
        cell.sliderLbl.tintColor = UIColor.black
        cell.iconImg.image = UIImage(named: iconArray [indexPath.row])
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        self.sliderDelegate?.getSliderIndex(index: indexPath.row)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 1
        
        
    }
}
