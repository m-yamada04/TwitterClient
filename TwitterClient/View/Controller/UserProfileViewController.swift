//
//  UserProfileViewController.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/29.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User?
    
    private var viewModel: UserProfileViewModel?

    @IBOutlet weak var _userTweetListView: UITableView!  {
        didSet {
            _userTweetListView.rowHeight = UITableViewAutomaticDimension
            // プロフィール
            let profileCellName = String(describing: ProfileCell.self)
            let profileNib = UINib(nibName: profileCellName , bundle: nil)
            _userTweetListView.register(profileNib, forCellReuseIdentifier: profileCellName)
            // ローディング中
            let loadingCellName = String(describing: LoadingTweetCell.self)
            let loadingCell = UINib(nibName: loadingCellName , bundle: nil)
            _userTweetListView.register(loadingCell, forCellReuseIdentifier: loadingCellName)
            // ツイート
            let tweetCellName = String(describing: TweetCell.self)
            let tweetNib = UINib(nibName: tweetCellName , bundle: nil)
            _userTweetListView.register(tweetNib, forCellReuseIdentifier: tweetCellName)
            // ツイート0件
            let noneTweetCellName = String(describing: NoneTweetCell.self)
            let noneTweetNib = UINib(nibName: noneTweetCellName , bundle: nil)
            _userTweetListView.register(noneTweetNib, forCellReuseIdentifier: noneTweetCellName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = user?.name
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // データ取得成功時にテーブルを更新
        self.viewModel = UserProfileViewModel(
            userId: user!.id,
            succeed: { () -> Void in
                self._userTweetListView.reloadData()
        }, failed: { () -> Void in
            debugPrint("nothing timeline")
        })
    }
}

// MARK: UITableView

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.viewModel?.tweets {
            return 1 + tweets.count
        } else {
            return 2 // profile + loading
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 先頭のセルはプロフィール、それ以外はツイート関連
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProfileCell.self), for: indexPath) as! ProfileCell
            profileCell.user = self.user
            return profileCell
        } else {
            if let tweets = viewModel?.tweets {
                if tweets.count == 0 {
                    // 表示したユーザーのツイートが0件だった
                    return tableView.dequeueReusableCell(
                        withIdentifier: String(describing: NoneTweetCell.self), for: indexPath)
                }
                let tweetCell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: TweetCell.self), for: indexPath) as! TweetCell
                tweetCell.tweet = tweets[indexPath.row - 1]
                return tweetCell
            } else {
                // 読み込み中のセル
                let loadingCell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: LoadingTweetCell.self), for: indexPath) as! LoadingTweetCell
                return loadingCell
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール先が一番下部分だった場合、古いツイートを取得
        if scrollView.contentOffset.y + scrollView.frame.size.height
            > scrollView.contentSize.height && scrollView.isDragging {
            let offset = scrollView.contentOffset
            // データ取得成功時にテーブルを更新
            self.viewModel?.fetchOlder(
                succeed: { () -> Void in
                    self._userTweetListView.reloadData()
                    self._userTweetListView.setContentOffset(offset, animated: true)
            }, failed: { () -> Void in
                debugPrint("nothing timeline")
            })
        }
    }
}
