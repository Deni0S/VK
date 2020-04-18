//
//  Photo.swift
//  VK
//
//  Created by Денис Баринов on 26.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var text: String = ""
    convenience init(json: JSON) {
        self.init()
        self.url = json["sizes"][3]["url"].stringValue
        self.text = json["text"].stringValue
    }
    override static func primaryKey() -> String? {
        return "url"
    }
}