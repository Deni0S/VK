//
//  VKService.swift
//  VK
//
//  Created by Денис Баринов on 24.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

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
            return "count=100"
        }
    }
}

class VKService {
    let baseURL: String = "https://api.vk.com/method/"
    var baseParameters: String {
        return "access_token=\(Session.instance.token)&v=5.101"
    }
    // Дополнительный параметр запроса
    var additionalParametr = ""
    // Получить URL
    func getURLpath(for method: VKServiceMethod) -> String {
        var param = ""
        if method.parameters.count > 0 {
            param += "&"
        }
        let URLpath = baseURL + method.methodName + "?" + "\(additionalParametr)" + method.parameters + param + baseParameters
        return URLpath
    }
    
    // Фотографии
    func getPhoto(id: String, complition: ((Error?) -> Void)? = nil) {
        // Добавим дополнительный параметр id пользователя
        additionalParametr = "owner_id=\(id)&"
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getPhoto)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                complition?(error)
                print(error)
            } else {
                // SwiftyJSON cериализация
                if let json = try? JSON(data: responce.value!) {
                    print("\nJson Фотографии:\n", json)
                    // SwiftyJSON Парсинг
                    let photo = json["response"]["items"].arrayValue.map { Photo(json: $0) }
                    print("\nФотографии:\n\(photo)")
                    // Сохранить в Realm
                    self.savePhotoData(photo)
                    // Передадим данные через замыкание
                    complition?(nil)
                }
            }
        }
    }
    
    // Сохранить фото в Realm
    func savePhotoData(_ vk: [Photo]) {
        let realm = try! Realm()
        let oldPhoto = realm.objects(Photo.self)
        do {
            try realm.write {
                realm.delete(oldPhoto)
                realm.add(vk, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    // Друзья
    func getFriend(complition: ((Error?) -> Void)? = nil) {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getFriend)
        // Статический метод полчения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                complition?(error)
                print(error)
            } else {
                // SwiftyJSON cериализация
                if let json = try? JSON(data: responce.value!) {
                    print("\nJson Друзья:\n", json)
                    // SwiftyJSON Парсинг
                    let friend = json["response"]["items"].arrayValue.map { User(json: $0) }
                    print("\nДрузья:\n\(friend)")
                    // Сохранить в Realm
                    self.saveFriendData(friend)
                    // Передадим данные через замыкание
                    complition?(nil)
                }
            }
        }
    }
    
    // Сохранить друзей в Realm
    func saveFriendData(_ vk: [User]) {
        let realm = try! Realm()
        let oldFriend = realm.objects(User.self)
        do {
            try realm.write {
                realm.delete(oldFriend)
                realm.add(vk, update: .all)
            }
            
        } catch {
            print(error)
        }
    }
    
    // Группы
    func getGroup(complition: ((Error?) -> Void)? = nil) {
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getGroup)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                complition?(error)
                print(error)
            } else {
                // SwiftyJSON cериализация
                if let json = try? JSON(data: responce.value!) {
                    print("\nJson Группы:\n", json)
                    let group = json["response"]["items"].arrayValue.map { Group(json: $0) }
                    print("\nГруппы:\n\(group)")
                    // Сохранить в Realm
                    self.saveGroupData(group)
                    // Передадим данные через замыкание
                    complition?(nil)
                }
            }
        }
    }
    
    // Сохранить группы в Realm
    func saveGroupData(_ vk: [Group]) {
        let realm = try! Realm()
        let oldGroup = realm.objects(Group.self)
        do {
            try realm.write {
                realm.delete(oldGroup)
                realm.add(vk, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    // Поиск групп
    func getGroupSearch(search: String, complition: (([Group]?, (Error?)) -> Void)? = nil) {
        // Добавить дополнительный параметр для поискового запроса
        additionalParametr = "q=\(search)&"
        // Создать URL по частям
        let urlPath = self.getURLpath(for: .getGroupSearch)
        // Статический метод получения ответа Alamofire
        AF.request(urlPath).responseData {responce in
            // Обработать ошибки
            if let error = responce.error {
                complition?(nil, error)
                print(error)
            } else {
                // SwiftyJSON cериализация
                if let json = try? JSON(data: responce.value!) {
                    print("\nJson Поиск групп:\n", json)
                    // SwiftyJSON Парсинг
                    let groupSearch = json["response"]["items"].arrayValue.map { Group(json: $0) }
                    print("\nПоиск групп:\n\(groupSearch)")
                    // Передадим данные через замыкание
                    complition?(groupSearch, nil)
                }
            }
        }
    }
}
