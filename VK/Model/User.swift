//
//  User.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var id: String = ""
    var FirstName: String = ""
    var LastName: String = ""
    var PhotoFriend: String = ""
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.FirstName = json["first_name"].stringValue
        self.LastName = json["last_name"].stringValue
        self.PhotoFriend = json["photo_200_orig"].stringValue
    }
}

// Заставим наш объект выводиться в консоль
extension User: CustomStringConvertible {
    var description: String {
        return "\n \(FirstName) \(LastName): vk.com/id\(id)"
    }
}
