//
//  Group.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var PhotoGroup: String = ""
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.Name = json["name"].stringValue
        self.PhotoGroup = json["photo_200"].stringValue
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
