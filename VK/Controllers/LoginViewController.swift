//
//  LoginViewController.swift
//  VK
//
//  Created by Денис Баринов on 14.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var loginTextInput: UITextField!
    @IBOutlet weak var passwordText: UILabel!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    // MARK: - Сразу после загрузки ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Добавим жест нажатия.
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        // Присваиваем его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Кнопка войти
    @IBAction func InterButton(_ sender: Any) {
    // Получаем текст логина
        let login = loginTextInput.text!
        // Получаем текст пароля
        let password = passwordTextInput.text!
        // Проверяем верны ли они
        if login == "admin" && password == "admin" {
            print("Успешная авторизация")
        } else {
            print("Ошибка в Логине(\(loginTextInput.text!)) или Пароле(\(passwordTextInput.text!))")
        }
    }
    
    // MARK: - Кнопка выйти
    @IBAction func logOutVK(unwindSegue: UIStoryboardSegue) {
    }
    
    // MARK: - Проверка логина и пароля при переходе
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Проверяем данные
        let checkResult = checkUserData()
        // Если данные неверны, покажем ошибку
        if !checkResult {
            showLoginError()
        }
        // Вернем результат
        return checkResult
    }
    
    // MARK: - Проверяем данные пользователя
    func checkUserData() -> Bool {
        // Получаем текст логина и пароля.
        guard let login = loginTextInput.text, let password = passwordTextInput.text else {
            return false
        }
        // Проверяем верны ли они
        if login == "admin" && password == "admin" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Сообщение об ошибке логина или пароля
    func showLoginError() {
        // Создадим в контроллере вывода сообщение
        let alter = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlterAction
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlterAction
        alter.addAction(action)
        // Покаываем UIAlterController
        present(alter, animated: true, completion: nil)
    }
    
    // MARK: - Когда​ к​лавиатура​​ появляется
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем​​ размер​ к​лавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Когда появляется ViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Подписываемся на уведомление о​​ появлении​ к​лавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Подписываемся на уведомление об исчезновении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Скрыть NavigationController с окна Login (Перенесли в Storyboard)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Когда закрывается ViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Отписаться от уведомлений, когда они не нужны
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        // Показать NavigationController на последующих окнах (Перенесли в Storyboard)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Исчезновение клавиатуры при клике по пустому месту
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}
