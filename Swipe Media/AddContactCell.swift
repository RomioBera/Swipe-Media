//
//  AddContactCell.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 27/08/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit

class AddContactCell: UITableViewCell {

    @IBOutlet var followBtn: UIButton!
    
    @IBOutlet var userName: UITextView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var unfollowBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
