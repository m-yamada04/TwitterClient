//
//  TwitterManager.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/30.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import TwitterKit

fileprivate let twitterManager = TwitterManager()

class TwitterManager {
    let maxCount = 30
    
    private let statusesURL = "https://api.twitter.com/1.1/statuses"
    var error: NSError?
    
    class var shared : TwitterManager {
        return twitterManager
    }
    
    func login(succeed: @escaping () -> Void, failed: @escaping () -> Void)  {
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            succeed()
        } else {
            TWTRTwitter.sharedInstance().logIn { session, error in
                guard let _ = session else {
                    if let _ = error {
                        failed()
                    } else {
                        succeed()
                    }
                    return
                }
                failed()
            }
        }
    }
    
    /**
     ログイン済みユーザーのタイムラインを取得する
     - parameter sinceId: 入力時、指定ID以降のツイートを取得
     - parameter maxId: 入力時、指定ID以前のツイートのみ取得
     - parameter succeed: 成功時の処理
     - parameter failed: 失敗時の処理
     */
    func getTimeLineTweets(sinceId: String?, maxId: String?,
                           succeed: @escaping ((_: Data) -> Void), failed: @escaping (() -> Void)) {
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
            debugPrint("auth invalid")
            return
        }
        if sinceId != nil && maxId != nil {
            assertionFailure("either sinceId or maxId")
        }
        let path = "/home_timeline.json"
        
        let apiClient = TWTRAPIClient(userID: session.userID)
        var parameters =  [ "count": String(maxCount) ]
        if sinceId != nil {
            // タイムラインの場合、指定ID以降指定の場合は件数指定を解除し、一旦全件取得しておく
            parameters["count"] = nil
            parameters["since_id"] = sinceId!
        }
        if maxId != nil {
            parameters["max_id"] = maxId!
        }
        let request = apiClient.urlRequest(
            withMethod:  "GET",
            urlString: statusesURL + path,
            parameters: parameters,
            error: &error
        )
        apiClient.sendTwitterRequest(request) { response, data, error in
            if let error = error {
                debugPrint(error)
                failed()
            } else if let data = data {
                succeed(data)
            }
        }
    }

    /**
     指定ユーザーのツイート一覧を取得する
     - parameter userId: 指定するユーザ
     - parameter sinceId: 入力時、指定ID以降のツイートを取得
     - parameter maxId: 入力時、指定ID以前のツイートのみ取得
     - parameter succeed: 成功時の処理
     - parameter failed: 失敗時の処理
     */
    func getUserTweets(userId: String, sinceId: String?, maxId: String?,
                       succeed: @escaping ((_: Data) -> Void), failed: @escaping (() -> Void)) {
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
            debugPrint("auth invalid")
            return
        }
        if sinceId != nil && maxId != nil {
            assertionFailure("either sinceId or maxId")
        }
        let path = "/user_timeline.json"
        
        let apiClient = TWTRAPIClient(userID: session.userID)
        var parameters =  [
            "user_id": userId,
            "count": String(maxCount)
        ]
        if sinceId != nil {
            parameters["since_id"] = sinceId!
        }
        if maxId != nil {
            parameters["max_id"] = maxId!
        }
        let request = apiClient.urlRequest(
            withMethod:  "GET",
            urlString: statusesURL + path,
            parameters: parameters,
            error: &error
        )
        apiClient.sendTwitterRequest(request) { response, data, error in
            if let error = error {
                debugPrint(error)
                failed()
            } else if let data = data {
                succeed(data)
            }
        }
    }
}
