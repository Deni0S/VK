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
//import Firebase

enum VKServiceMethod {
    case getPhoto
    case getFriend
    case getGroup
    case getGroupSearch
    case getNews
    
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
        case .getNews:
            return "newsfeed.get"
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
        case .getNews:
            return "filters=post,photo&return_banned=0"
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
    let photoQueue = DispatchQueue(label: "Photo Queue", qos: .utility)
    let friendQueue = DispatchQueue(label: "Friend Queue", qos: .utility)
    let groupQueue = DispatchQueue(label: "Group Queue", qos: .utility)
    let groupSearchQueue = DispatchQueue(label: "GroupSearch Queue", qos: .utility)
    let newsQueue = DispatchQueue(label: "News Queue", qos: .utility)
    
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
        // Перейти в последовательную, фоновую очередь для фотографий
        photoQueue.async {
            // Добавим дополнительный параметр id пользователя
            self.additionalParametr = "owner_id=\(id)&"
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
                        // Вызвать кусочек кода в главном потоке асинхронно
                        DispatchQueue.main.async {
                            // Передадим данные через замыкание
                            complition?(nil)
                        }
                    }
                }
            }
        }
    }
    
    // Сохранить фото в Realm
    func savePhotoData(_ vk: [Photo]) {
        // Выполнить в одиночку, чтобы приложение не вылетало при удалении Realm
        photoQueue.async(flags: .barrier) {
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
    }
    
    // Друзья
    func getFriend(complition: ((Error?) -> Void)? = nil) {
        // Перейти в последовательную, фоновую очередь для друзей
        friendQueue.async {
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
                        // Вызвать кусочек кода в главном потоке асинхронно
                        DispatchQueue.main.async {
                            // Передадим данные через замыкание
                            complition?(nil)
                        }
                    }
                }
            }
        }
    }
    
    // Сохранить друзей в Realm
    func saveFriendData(_ vk: [User]) {
        // Выполнить в одиночку, чтобы приложение не вылетало при удалении Realm
//        friendQueue.async(flags: .barrier) {
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
//        }
    }
    
    // Группы
    func getGroup(complition: ((Error?) -> Void)? = nil) {
        // Перейти в последовательную, фоновую очередь для групп
        groupQueue.async {
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
                        // Вызвать кусочек кода в главном потоке асинхронно
                        DispatchQueue.main.async {
                            // Передадим данные через замыкание
                            complition?(nil)
                        }
                    }
                }
            }
        }
    }
    
    // Сохранить группы в Realm
    func saveGroupData(_ vk: [Group]) {
        // Выполнить в одиночку, чтобы приложение не вылетало при удалении Realm
        groupQueue.async(flags: .barrier) {
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
    }
    
    // Поиск групп
    func getGroupSearch(search: String, complition: (([Group]?, (Error?)) -> Void)? = nil) {
        // Перейти в последовательную, фоновую очередь для поиска по группам
        groupSearchQueue.async {
            // Добавить дополнительный параметр для поискового запроса
            self.additionalParametr = "q=\(search)&"
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
                        // Сохранить группы в Firestore
//                    self.saveGroupSearchFirestore(groupSearch)
                        // Вызвать кусочек кода в главном потоке асинхронно
                        DispatchQueue.main.async {
                            // Передадим данные через замыкание
                            complition?(groupSearch, nil)
                        }
                    }
                }
            }
        }
    }
    
    /* // Сохранить группы в Firestore
    func saveGroupSearchFirestore(_ vk: [Group]) {
        // Перейти в последовательную, фоновую очередь для поиска по группам
        groupSearchQueue.async(flags: .barrier) {
            let db = Firestore.firestore()
            db.collection("id\(Session.instance.userid)").document("GroupSearch").setData(vk
                .map { $0.toFirestore() }
                .reduce([:]) { $0.merging($1) { (current, _) in current } }
            ) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else { print("data saved") }
            }
        }
    }
     */

    // Новости
    func getNews(complition: ((Error?) -> Void)? = nil) {
        // Перейти в последовательную, фоновую очередь для новостей
        newsQueue.async {
            // Создать URL по частям
            let urlPath = self.getURLpath(for: .getNews)
            // Статический метод получения ответа Alamofire
            AF.request(urlPath).responseData {responce in
                // Обработать ошибки
                if let error = responce.error {
                    // Вызвать кусочек кода в главном потоке асинхронно
                    DispatchQueue.main.async {
                        complition?(error)
                    }
                } else {
                    // SwiftyJSON Cериализация
                    if let json = try? JSON(data: responce.value!) {
//                        debugPrint(json)
                        // SwiftyJSON Парсинг
                        let newsProfiles = json["response"]["profiles"].arrayValue.map { NewsProfiles(json: $0) }
                        let newsGroups = json["response"]["groups"].arrayValue.map { NewsGroups(json: $0) }
//                        debugPrint(newsProfiles, newsGroups)
                        // Сохранить источник  новостей в базу Realm
                        self.saveSourceNews (newsProfiles, newsGroups)
                        let news = json["response"]["items"].arrayValue.map { News(json: $0) }
//                        debugPrint(news)
                        // Сохранить новости вместе с исночниками в Realm
                        self.saveNewsData(news)
                        // Вызвать кусочек кода в главном потоке асинхронно
                        DispatchQueue.main.async {
                            // Передать данные через замыкание
                            complition?(nil)
                        }
                    }
                }
            }
        }
    }
    
    // Сохранить в Realm источники новостей
    func saveSourceNews(_ pr: [NewsProfiles], _ gr: [NewsGroups]) {
        let realm = try! Realm()
        let oldNewsProfiles = realm.objects(NewsProfiles.self)
        let oldNewsGroups = realm.objects(NewsGroups.self)
        do {
            try realm.write {
                realm.delete(oldNewsProfiles)
                realm.delete(oldNewsGroups)
                realm.add(pr, update: .all)
                realm.add(gr, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    // Сохранить в Realm новости вместе с источниками
    func saveNewsData(_ ns: [News]) {
        // Выполнить в одиночку, чтобы приложение не вылетало при удалении Realm
        newsQueue.async(flags: .barrier) {
            let realm = try! Realm()
            let oldNews = realm.objects(News.self)
            do {
                try realm.write {
                    realm.delete(oldNews)
                    realm.add(ns, update: .all)
                }
            } catch {
                print(error)
            }
        }
    }
}
