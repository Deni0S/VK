//
//  NewsGroups.swift
//  VK
//
//  Created by Денис Баринов on 19.4.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NewsGroups: Object {
    @objc dynamic var Id: Int = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Avatar: String = ""
    convenience init(json: JSON) {
        self.init()
        self.Id = json["id"].intValue
        self.Name = json["name"].stringValue
        self.Avatar = json["photo_100"].stringValue
    }
    override static func primaryKey() -> String? {
        return "Id"
    }
}
