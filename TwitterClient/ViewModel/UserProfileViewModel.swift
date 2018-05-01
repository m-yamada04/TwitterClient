//
//  UserProfileViewModel.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/05/01.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import Realm
import RealmSwift

class UserProfileViewModel {
    let userId: String
    var tweets: [Tweet]?
    
    init(userId: String, succeed: @escaping () -> Void, failed: @escaping () -> Void) {
        self.userId = userId
        // ユーザー指定でのツイート一覧は現在ローカルDBに保持していないため、TwitterAPIでの値取得のみ
        TwitterManager.shared.getUserTweets(
            userId: userId, sinceId: nil, maxId: nil,
            succeed: { data -> Void in
                // Realmへの保存はしない
                self.tweets = JSONSerializer.shared.serializeTweets(
                    input: "", responseData: data)
                succeed()
        }, failed: { () -> Void in
            debugPrint("get user timeline failed")
            failed()
        })
    }
    
    func fetchOlder(succeed: @escaping () -> Void, failed: @escaping () -> Void) {
        // 現在表示中のうち、一番古いツイートより古いものを取得
        // ユーザー指定でのツイート一覧は現在ローカルDBに保持していないため、TwitterAPIでの値取得のみ
        TwitterManager.shared.getUserTweets(
            userId: userId, sinceId: nil, maxId: self.tweets?.last?.id,
            succeed: { data -> Void in
                if let newTweets = JSONSerializer.shared.serializeTweets(
                    // Realmへの保存はしない
                    input: "", responseData: data) {
                    // 先頭のレコードは重複のため除外
                    if (newTweets.count > 1) {
                        self.tweets = self.tweets! + newTweets[1...]
                    }
                }
                succeed()
        }, failed: { () -> Void in
            debugPrint("get user timeline failed")
            failed()
        })
    }
}
