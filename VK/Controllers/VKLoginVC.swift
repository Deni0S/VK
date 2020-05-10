//
//  VKLoginVC.swift
//  VK
//
//  Created by Денис Баринов on 24.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import WebKit

class VKLoginVC: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            // Сделать себя делегатом
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Проверить создался ли объект
        if let request = vkAuthRequest() {
            // Загрузить страничку по этому адресу и отобразить в компаненте
            webView.load(request)
        }
    }
    
    // MARK: - Кнопка выйти
    @IBAction func logOutVK(unwindSegue: UIStoryboardSegue) {
        // Выйти из VK
        Session.instance.logoutVK()
        // Уничтожить контроллер представления, который представил этот контроллер
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Вернуть URLRequest
    func vkAuthRequest() -> URLRequest? {
        // URL Components
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "http"
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: "6675875"), // id приложения
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html" ), // переход
            URLQueryItem(name: "response_type", value: "token" ), // ключ доступа
            URLQueryItem(name: "scope", value: "photos, friends, groups, offline, wall" ), // получить доступ (offline - бессрочный token)
            URLQueryItem(name: "v", value: "5.101" ) // последняя версия
        ]
        // Безопасно вызвать
        guard let url = urlConstructor.url else { return nil }
        // Вернуть объект URLRequest
        return URLRequest(url: url)
    }
    
    // Вернуть данные пользователя
    func loadData() {
        let service = VKService()
        service.getPhoto()
        service.getFriend()
        service.getGroup()
        service.getGroupSearch(search: "Music")
    }
}

// С протоколом удобнее работать через расширение
extension VKLoginVC: WKNavigationDelegate {
    // Метод реализуемый протоколом WKNavigationDelegate, вызывается перед загрузкой адреса
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Swift.Void) {
        // Взять URL для перехода
        guard let url = navigationResponse.response.url,
            // Проверить содержит ли URL: /blank.html
            url.path == "/blank.html",
            // Если содержит значит нам ответил сервер, срабатывает обратный редирект
            let fragment = url.fragment else {
                // Обязательно нужно вернуть разрешает (allow) или запрещает (cancel) загрузить адреc
                decisionHandler(.allow)
                return
        }
        // Извлечь из редиректа token
        let params = fragment
            // Разделить строку по знаку амперсанд
            .components(separatedBy: "&")
            // Разделить строку по знаку равно
            .map({ $0.components(separatedBy: "=")})
            // Создать dictionary (словарь)
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        // Попытаться получить в словаре params поле user_id
        if let id = params["user_id"] {
            // Печатаем id
            print("\nUser id: \n", id)
            // Сохранить id в Singleton
            Session.instance.userid = id
        }
        // Попытаться получить в словаре params поле access_token
        if let token = params["access_token"] {
            // Печатать token
            print("\nToken: \n", token)
            // Сохранить token в Singleton
            Session.instance.token = token
            // Вывести данные в консоль
            loadData()
            // Перейти в контроллер LoadUserData
            performSegue(withIdentifier: "LoadUserData", sender: nil)
        }
        // Обязательно нужно вернуть разрешает (allow) или запрещает (cancel) загрузить адреc
        decisionHandler(.allow)
    }
}


