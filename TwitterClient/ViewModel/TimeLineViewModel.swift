//
//  TimeLineViewModel.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/30.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import Realm
import RealmSwift

class TimeLineViewModel {
    var tweets: [Tweet]?
    
    init(succeed: @escaping () -> Void, failed: @escaping () -> Void) {
        let realm = try! Realm()
        let tweets = realm.objects(Tweet.self)
        if tweets.count > 0 {
            self.tweets = Array(tweets.sorted(
                byKeyPath: "createdAt", ascending: false)[0...(min(tweets.count, TwitterManager.shared.maxCount) - 1)])
            succeed()
        } else {
            TwitterManager.shared.getTimeLineTweets(
                sinceId: nil, maxId: nil,
                succeed: { data -> Void in
                    self.tweets = JSONSerializer.shared.serializeTweets(
                        input: String(describing: Tweet.self), responseData: data)
                    succeed()
            }, failed: { () -> Void in
                debugPrint("get timeline failed")
                failed()
            })
        }
    }
    
    func refresh(succeed: @escaping () -> Void, failed: @escaping () -> Void) {
        // 現在表示中のうち、一番新しいツイートより新しいものを取得
        let realm = try! Realm()
        let tweets = realm.objects(Tweet.self).filter("createdAt > %d", self.tweets!.first!.createdAt)
        if tweets.count > 0 {
            self.tweets = Array(tweets.sorted(byKeyPath: "createdAt", ascending: false)) + self.tweets!
            succeed()
        } else {
            // 現在保持しているうち、一番新しいレコード以降を取得
            TwitterManager.shared.getTimeLineTweets(
                sinceId: self.tweets!.first!.id, maxId: nil,
                succeed: { data -> Void in
                    if let newTweets = JSONSerializer.shared.serializeTweets(
                        input: String(describing: Tweet.self), responseData: data) {
                        self.tweets = newTweets + self.tweets!
                    }
                    // 一定件数を超えた場合、古いレコードを削除
                    // TODO: Realm側のレコード削除
                    if self.tweets!.count > TwitterManager.shared.maxCount {
                        let range = TwitterManager.shared.maxCount...(self.tweets!.count - 1)
                        self.tweets?.removeSubrange(range)
                    }
                    succeed()
            }, failed: { () -> Void in
                debugPrint("get timeline failed")
                failed()
            })
        }
    }
    
    func fetchOlder(succeed: @escaping () -> Void, failed: @escaping () -> Void) {
        // 現在表示中のうち、一番古いツイートより古いものを取得
        let realm = try! Realm()
        let tweets = realm.objects(Tweet.self).filter("createdAt < %d", self.tweets!.last!.createdAt)
        if tweets.count > 0 {
            self.tweets = self.tweets! + Array(tweets.sorted(byKeyPath: "createdAt", ascending: false))
        } else {
            // 現在保持しているうち、一番古いレコード以前を取得
            TwitterManager.shared.getTimeLineTweets(
                sinceId: nil, maxId: self.tweets!.last!.id,
                succeed: { data -> Void in
                    if let newTweets = JSONSerializer.shared.serializeTweets(
                        input: String(describing: Tweet.self), responseData: data) {
                        // 先頭のレコードは重複のため除外
                        if (newTweets.count > 1) {
                             self.tweets = self.tweets! + newTweets[1...]
                        }
                    }
                    succeed()
            }, failed: { () -> Void in
                debugPrint("get timeline failed")
                failed()
            })
        }
    }
}
