//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/28.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var _userIcon: CircleImageView!
    @IBOutlet weak var _displayName: UILabel!
    @IBOutlet weak var _userName: UILabel!
    @IBOutlet weak var _tweetText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
