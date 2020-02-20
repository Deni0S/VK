//
//  Session.swift
//  VK
//
//  Created by Денис Баринов on 20.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation

//  Singleton для хранения данных авторизации
class Session {
    var token = ""
    var userid = ""
    private init() {}
    static let instance = Session()
}
