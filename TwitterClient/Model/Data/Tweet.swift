//
//  Tweet.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/30.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Tweet: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var owner: User? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum TweetCodingKeys: String, CodingKey {
        case id = "id_str"
        case text = "text"
        case createdAt = "created_at"
        case user = "user"
    }
    
    convenience init(id: String, text: String, createdAt: String, user: User) {
        self.init()
        self.id = id
        self.text = text
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        self.createdAt = formatter.date(from: createdAt)!
        self.owner = user
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TweetCodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let text = try container.decode(String.self, forKey: .text)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let user = try container.decode(User.self, forKey: .user)
        self.init(id: id, text: text, createdAt: createdAt, user: user)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
