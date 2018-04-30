//
//  UserProfileViewController.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/29.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var _userTweetListView: UITableView!  {
        didSet {
            _userTweetListView.rowHeight = UITableViewAutomaticDimension
            // プロフィール
            let profileCellName = String(describing: ProfileCell.self)
            let profileNib = UINib(nibName: profileCellName , bundle: nil)
            _userTweetListView.register(profileNib, forCellReuseIdentifier: profileCellName)
            // ツイート
            let tweetCellName = String(describing: TweetCell.self)
            let tweetNib = UINib(nibName: tweetCellName , bundle: nil)
            _userTweetListView.register(tweetNib, forCellReuseIdentifier: tweetCellName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableView

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100 // 仮
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 先頭のセルはプロフィール、それ以外はツイート
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProfileCell.self), for: indexPath) as! ProfileCell
        } else {
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TweetCell.self), for: indexPath) as! TweetCell
        }
        return cell
    }
}
