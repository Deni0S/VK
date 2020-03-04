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
}

// У Realm свой дескриптор
//// Заставим наш объект выводиться в консоль
//extension User: CustomStringConvertible {
//    var description: String {
//        return "\n \(FirstName) \(LastName): vk.com/id\(id)"
//    }
//}
