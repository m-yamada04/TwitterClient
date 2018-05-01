//
//  JSONSerializer.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/30.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import CoreFoundation
import RealmSwift

fileprivate let jsonSerializer = JSONSerializer()

class JSONSerializer {
    
    class var shared : JSONSerializer {
        return jsonSerializer
    }
    
    func serializeTweets(input sourceName: String, responseData: Data) -> [Tweet]? {
        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
            guard json is [AnyObject] else {
                assertionFailure("failed to parse")
                return nil
            }
            let jsonDecoder = JSONDecoder()
            do {
                switch sourceName {
                case String(describing: Tweet.self):
                    // タイムラインのツイート
                    let tweets = try jsonDecoder.decode([Tweet].self, from: responseData)
                    defer {
                        let realm = try! Realm()
                        for tweet in tweets {
                            try! realm.write {
                                realm.add(tweet, update: true)
                            }
                        }
                    }
                    return tweets
                default:
                    // ユーザ情報のツイート (ローカルDBへの保持をしない)
                    let tweets = try jsonDecoder.decode([Tweet].self, from: responseData)
                    return tweets
                }
            } catch {
                assertionFailure("failed to convert data")
            }
            
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
