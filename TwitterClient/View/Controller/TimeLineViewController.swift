//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/27.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit
import TwitterKit
import RxSwift
import RxCocoa

class TimeLineViewController: UIViewController {
    
    @IBOutlet weak var _tweetListView: UITableView! {
        didSet {
            _tweetListView.rowHeight = UITableViewAutomaticDimension
            let tweetCellName = String(describing: TweetCell.self)
            let nib = UINib(nibName: tweetCellName , bundle: nil)
            _tweetListView.register(nib, forCellReuseIdentifier: tweetCellName)
        }
    }
    private var scrollBeganPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableView

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100 // 仮
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TweetCell.self), for: indexPath) as! TweetCell
        return cell
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
    }
}

