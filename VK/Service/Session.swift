//
//  Session.swift
//  VK
//
//  Created by Денис Баринов on 20.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import WebKit

//  Singleton для хранения данных авторизации
class Session {
    var token = ""
    var userid = ""
    var photoUserId = ""
    private init() {}
    static let instance = Session()
    
    // Выйти из VK
    func logoutVK() {
        // Создадть объект хранилища данных сайта
        let dataStore = WKWebsiteDataStore.default()
        // Извлечь данные всех типов и удалить соответствующие фильтру vk
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                for: records.filter { $0.displayName.contains("vk")},
                completionHandler: { }
            )
        }
    }
}
