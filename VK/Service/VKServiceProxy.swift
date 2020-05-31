//
//  VKServiceProxy.swift
//  VK
//
//  Created by Денис Баринов on 31.5.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation

class VKServiceProxy: VKServiceInterface {
    let vkService: VKService
    init(vkService: VKService) {
        self.vkService = vkService
    }
    
    func getPhoto(id: String? = nil, complition: ((Error?) -> Void)? = nil) {
        self.vkService.getPhoto(id: id, complition: complition)
        print("Called func getPhoto")
    }
    
    func getFriend(complition: ((Error?) -> Void)? = nil) {
        self.vkService.getFriend(complition: complition)
        print("Called func getFriend")
    }
    
    func getGroup(complition: ((Error?) -> Void)? = nil) {
        self.vkService.getGroup(complition: complition)
        print("Called func getGroup")
    }
    
    func getGroupSearch(search: String, complition: (([Group]?, (Error?)) -> Void)? = nil) {
        self.vkService.getGroupSearch(search: search, complition: complition)
        print("Called func getGroupSearch")
    }
    
    func getNews(dateLastNews: Double? = nil, isRefresh: Bool = false, complition: ((Error?) -> Void)? = nil) {
        self.vkService.getNews(dateLastNews: dateLastNews, isRefresh: isRefresh, complition: complition)
        print("Called func getNews")
    }
    
}
