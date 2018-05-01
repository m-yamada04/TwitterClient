//
//  User.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/30.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var profileImageUrl: String = ""
    @objc dynamic var profileBackgroundImageUrl: String = ""
    @objc dynamic var profileBackgroundColor:  String = ""
    @objc dynamic var profileDescription: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum UserCodingKeys: String, CodingKey {
        case id = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url_https"
        case profileBackgroundImageUrl = "profile_background_image_url_https"
        case profileBackgroundColor = "profile_background_color"
        case profileDescription = "description"
    }
    
    convenience init(id: String, name: String, screenName: String, profileImageUrl: String,
                     profileBackgroundImageUrl: String, profileBackgroundColor: String,
                     description: String) {
        self.init()
        self.id = id
        self.name = name
        self.screenName = screenName
        self.profileImageUrl = profileImageUrl
        self.profileBackgroundImageUrl = profileBackgroundImageUrl
        self.profileBackgroundColor = profileBackgroundColor
        self.profileDescription = description
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let screenName = try container.decode(String.self, forKey: .screenName)
        let profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        let profileBackgroundImageUrl = try container.decodeIfPresent(String.self, forKey: .profileBackgroundImageUrl) ?? ""
        let profileBackgroundColor = try container.decodeIfPresent(String.self, forKey: .profileBackgroundColor) ?? ""
        let description = try container.decode(String.self, forKey: .profileDescription)
        self.init(id: id, name: name, screenName: screenName, profileImageUrl: profileImageUrl,
                  profileBackgroundImageUrl: profileBackgroundImageUrl, profileBackgroundColor: profileBackgroundColor,
                  description: description)
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
