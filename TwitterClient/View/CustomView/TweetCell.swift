//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/28.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func useIconDidTap(user: User)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var _userIcon: CircleImageView!
    @IBOutlet weak var _displayName: UILabel!
    @IBOutlet weak var _userName: UILabel!
    @IBOutlet weak var _tweetText: UITextView!
    var delegate: TweetCellDelegate?
    
    var tweet: Tweet? {
        didSet {
            _userIcon.image = UIImage(data: try! Data(contentsOf: URL(string: tweet!.owner!.profileImageUrl)!))
            _displayName.text = tweet!.owner!.name
            _userName.text = "@" + tweet!.owner!.screenName
            _tweetText.text = tweet!.text
            _userIcon.addGestureRecognizer(
                UITapGestureRecognizer(target: self,
                action: #selector(TweetCell.userIconDidTap(_:)))
            )
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func userIconDidTap(_ sender: Any) {
        delegate?.useIconDidTap(user: self.tweet!.owner!)
    }
}
