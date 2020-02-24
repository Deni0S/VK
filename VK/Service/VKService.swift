//
//  VKService.swift
//  VK
//
//  Created by Денис Баринов on 24.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import Alamofire

enum VKServiceMethod {
    case getPhoto
    case getFriend
    case getGroup
    case getGroupSearch
    
    var methodName: String {
        switch self {
        case .getPhoto:
            return "photos.getAll"
        case .getFriend:
            return "friends.get"
        case .getGroup:
            return "groups.get"
        case .getGroupSearch:
            return "groups.search"
        }
    }
    
    var parameters: String {
        switch self {
        case .getPhoto:
            return "count=100"
        case .getFriend:
            return "fields=photo_200_orig"
        case .getGroup:
            return "extended=1"
        case .getGroupSearch:
            return "q=Music&count=100"
        }
    }
}

class VKService {
    let baseURL: String = "https://api.vk.com/method/"
        var baseParameters: String {
            return "access_token=\(Session.instance.token)&v=5.101"
        }
        var groupSearch = ""
        
        // Получить URL
        func getURLpath(for method: VKServiceMethod) -> String {
            var param = ""
            if method.parameters.count > 0 {
                param += "&"
            }
            let URLpath = baseURL + method.methodName + "?" + method.parameters + param + baseParameters
            return URLpath
        }
        
    // Фотографии
    func getPhoto() {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getPhoto)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                print(error)
            } else {
                // Cериализация
                if let json = try? JSONSerialization.jsonObject(with: responce.value!, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print("\nJson Фотографии:\n", json)
                }
            }
        }
    }
    
    // Друзья
    func getFriend() {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getFriend)
        // Статический метод полчения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                print(error)
            } else {
                // Cериализация
                if let json = try? JSONSerialization.jsonObject(with: responce.value!, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print("\nJson Друзья:\n", json)
                }
            }
        }
    }
        
    // Группы
    func getGroup() {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getGroup)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                print(error)
            } else {
                // Cериализация
                if let json = try? JSONSerialization.jsonObject(with: responce.value!, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print("\nJson Группы:\n", json)
                }
            }
        }
    }
    
    // Поиск групп
    func getGroupSearch() {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getGroupSearch)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                print(error)
            } else {
                // Cериализация
                if let json = try? JSONSerialization.jsonObject(with: responce.value!, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print("\nJson Поиск групп:\n", json)
                }
            }
        }
    }
}
