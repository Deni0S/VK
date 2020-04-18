//
//  User.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var FirstName: String = ""
    @objc dynamic var LastName: String = ""
    @objc dynamic var PhotoFriend: String = ""
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.FirstName = json["first_name"].stringValue
        self.LastName = json["last_name"].stringValue
        self.PhotoFriend = json["photo_200_orig"].stringValue
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
