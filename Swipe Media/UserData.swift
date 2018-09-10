//
//  UserData.swift
//  Swipe Media
//
//  Created by Amit Kumar Poreli on 03/09/18.
//  Copyright © 2018 Romio. All rights reserved.
//

import UIKit

class UserData: NSObject {
    
    var userName : String!
    var userProfileImg : String!
    var userId : String!
    var followingUser : [String] = [String]()
    var followersUser : [String] = [String]()
    var followingCount : Int!
    var followersCount : Int!
}
