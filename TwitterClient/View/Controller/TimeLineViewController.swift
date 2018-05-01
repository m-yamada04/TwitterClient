//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/27.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit
import TwitterKit

class TimeLineViewController: UIViewController {
    
    @IBOutlet weak var _tweetListView: UITableView! {
        didSet {
            _tweetListView.rowHeight = UITableViewAutomaticDimension
            // ローディング中
            let loadingCellName = String(describing: LoadingTweetCell.self)
            let loadingCell = UINib(nibName: loadingCellName , bundle: nil)
            _tweetListView.register(loadingCell, forCellReuseIdentifier: loadingCellName)
            // ツイート
            let tweetCellName = String(describing: TweetCell.self)
            let tweetNib = UINib(nibName: tweetCellName , bundle: nil)
            _tweetListView.register(tweetNib, forCellReuseIdentifier: tweetCellName)
            // ツイート0件
            let noneTweetCellName = String(describing: NoneTweetCell.self)
            let noneTweetNib = UINib(nibName: noneTweetCellName , bundle: nil)
            _tweetListView.register(noneTweetNib, forCellReuseIdentifier: noneTweetCellName)
        }
    }
    
    @IBOutlet weak var _loginButton: UIButton!
    
    private var viewModel: TimeLineViewModel?
    
    private let refreshControl = UIRefreshControl()
    
    private var scrollBeganPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull To Refresh設定
        _tweetListView.refreshControl = refreshControl
        refreshControl.addTarget(
            self, action: #selector(TimeLineViewController.refreshTweets(sender:)), for: .valueChanged)
        login()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 認証済みでデータの取得がまだの場合はデータ取得開始
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            self._tweetListView.isHidden = false
            self._loginButton.isHidden = true
            initTimeLineTweets()
        } else {
            // テーブルを非表示にしてログインボタンを表示
            self._tweetListView.isHidden = true
            self._loginButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToUserProfile") {
            let vc: UserProfileViewController = segue.destination as! UserProfileViewController
            vc.user = sender as? User
        }
    }
    
    @objc func refreshTweets(sender: UIRefreshControl) {
        // データ取得成功時にテーブルを更新
        self.viewModel?.refresh(
            succeed: { () -> Void in
                self._tweetListView.reloadData()
                self.refreshControl.endRefreshing()
        }, failed: { () -> Void in
            debugPrint("nothing timeline")
            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() && self.viewModel == nil {
            initTimeLineTweets()
        } else {
            login()
        }
    }
    
    private func login() {
        let succeed = {() -> Void in
            self.initTimeLineTweets()
        }
        let failed = {() -> Void in
            debugPrint("login failed")
        }
        TwitterManager.shared.login(succeed: succeed, failed: failed)
    }
    
    private func initTimeLineTweets() {
        // データ取得成功時にテーブルを更新
        self.viewModel = TimeLineViewModel(
            succeed: { () -> Void in
                self._tweetListView.reloadData()
        }, failed: { () -> Void in
            debugPrint("nothing timeline")
        })
    }
}

// MARK: UITableView

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel != nil {
            return viewModel?.tweets?.count ?? 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tweets = viewModel?.tweets {
            if tweets.count == 0 {
                // タイムラインのツイートが0件だった
                return tableView.dequeueReusableCell(
                    withIdentifier: String(describing: NoneTweetCell.self), for: indexPath)
            }
            let tweetCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TweetCell.self), for: indexPath) as! TweetCell
            tweetCell.tweet = tweets[indexPath.row]
            tweetCell.delegate = self
            return tweetCell
        } else {
            return tableView.dequeueReusableCell(
                withIdentifier: String(describing: LoadingTweetCell.self), for: indexPath)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeganPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let beganPoint = scrollBeganPoint else {
            return
        }
        // ナビゲーションバーの表示、非表示を切り替える
        if (beganPoint.y < scrollView.contentOffset.y) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        scrollBeganPoint = nil
        
        // スクロール先が一番下部分だった場合、古いツイートを取得
        if scrollView.contentOffset.y + scrollView.frame.size.height
            > scrollView.contentSize.height && scrollView.isDragging {
            let offset = scrollView.contentOffset
            // データ取得成功時にテーブルを更新
            self.viewModel?.fetchOlder(
                succeed: { () -> Void in
                    self._tweetListView.reloadData()
                    self._tweetListView.setContentOffset(offset, animated: true)
            }, failed: { () -> Void in
                debugPrint("nothing timeline")
            })
        }
    }
}

extension TimeLineViewController: TweetCellDelegate {
    func useIconDidTap(user: User) {
        performSegue(withIdentifier: "ToUserProfile", sender: user)
    }
}
