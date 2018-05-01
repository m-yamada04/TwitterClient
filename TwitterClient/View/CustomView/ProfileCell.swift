//
//  ProfileCell.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/28.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var _userHeader: UIImageView!
    @IBOutlet weak var _userIcon: CircleImageView!
    
    @IBOutlet weak var _displayName: UILabel!
    @IBOutlet weak var _userName: UILabel!
    @IBOutlet weak var _userProfile: UITextView!
    
    var user: User? {
        didSet {
            if !(user!.profileBackgroundImageUrl.isEmpty) {
                _userHeader.image = UIImage(data: try! Data(contentsOf: URL(string: user!.profileBackgroundImageUrl)!))
            }
            _userIcon.image = UIImage(data: try! Data(contentsOf: URL(string: user!.profileImageUrl)!))
            _displayName.text = user!.name
            _userName.text = "@" + user!.screenName
            _userProfile.text = user!.profileDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
