//
//  Group.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    var id: String = ""
    var Name: String = ""
    var PhotoGroup: String = ""
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.Name = json["name"].stringValue
        self.PhotoGroup = json["photo_200"].stringValue
    }
}

// Заставим наш объект выводиться в консоль
extension Group: CustomStringConvertible {
    var description: String {
        return "\n\n\(Name): \n\(PhotoGroup)\n,,,,,,,,,,,,,,,,,,,,,"
    }
}
