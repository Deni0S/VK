import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var loginText: UILabel!
    @IBOutlet private var loginTextInput: UITextField!
    @IBOutlet private var passwordText: UILabel!
    @IBOutlet private var passwordTextInput: UITextField!
    @IBOutlet private var activityView: UIView!
    @IBOutlet private var activityPoint1: UIView!
    @IBOutlet private var activityPoint2: UIView!
    @IBOutlet private var activityPoint3: UIView!
    
    // MARK: - Private Properties
    
    private var timerAnimation = Timer()
    
    // MARK: - Lifecycle
    
    // Сразу после загрузки ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // Когда закрывается ViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Отписаться от уведомлений, когда они не нужны
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        // Скрыть анимацию и остановить таймер для последующего открытия контроллера
        activityView.isHidden = true
        timerAnimation.invalidate()
    }
    
    // Проверка логина и пароля при переходе
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Запустим анимацию перехода
        pointAnimation()
        // Проверяем данные
        let checkResult = checkUserData()
        // Если данные неверны, покажем ошибку и уберем аниацию перехода с экрана
        if !checkResult {
            showLoginError()
            activityView.isHidden = true
        }
        // Вернем результат
        return checkResult
    }
    
}

// MARK: - Private Methods

private extension LoginViewController {
    
    func setupView() {
        // Добавим жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(self.hideKeyboard))
        // Присваиваем его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        // Подписываемся на уведомление о​​ появлении​ к​лавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        // Подписываемся на уведомление об исчезновении клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // Анимация перехода
    func pointAnimation() {
        activityView.isHidden = false
        self.activityPoint1.alpha = 0.3
        timerAnimation = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            UIView.animate(withDuration: 0.3, animations: {
                self.activityPoint1.alpha = 0.3
            }) { _ in
                self.activityPoint1.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.activityPoint2.alpha = 0.3
                }) { _ in
                    self.activityPoint2.alpha = 1
                    UIView.animate(withDuration: 0.3, animations: {
                        self.activityPoint3.alpha = 0.3
                    }) { _ in
                        self.activityPoint3.alpha = 1
                    }
                }
            }
        }
    }
    
    // Проверяем данные пользователя
    func checkUserData() -> Bool {
        // Вернем результат проверки логина и пароля
        "" == loginTextInput.text && "" == passwordTextInput.text
    }
    
    // Сообщение об ошибке логина или пароля
    func showLoginError() {
        // Создадим в контроллере вывода сообщение
        let alter = UIAlertController(title: "Ошибка",
                                      message: "Введены неверные данные пользователя",
                                      preferredStyle: .alert)
        // Создаем кнопку для UIAlterAction
        let action = UIAlertAction(title: "ОК",
                                   style: .cancel,
                                   handler: nil)
        // Добавляем кнопку на UIAlterAction
        alter.addAction(action)
        // Показываем UIAlterController
        present(alter, animated: true, completion: nil)
    }
    
    // Когда​ к​лавиатура​​ появляется
    @objc func keyboardWillShow(notification: Notification) {
        // Получаем​​ размер​ к​лавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: kbSize.height,
                                         right: 0.0)
        // Добавляем отступ внизу UIScrollView равный размеру клавиатуры
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // Когда клавиатура исчезает
    @objc func keyboardWillHide(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView равный 0
        scrollView?.contentInset = UIEdgeInsets.zero
        scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // Исчезновение клавиатуры при клике по пустому месту
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    // MARK: - IBActions

    // Кнопка войти
    @IBAction func InterButton(_ sender: Any) {
    // Получаем текст логина
        let login = loginTextInput.text!
        // Получаем текст пароля
        let password = passwordTextInput.text!
        // Проверяем верны ли они
        if login == "admin" && password == "admin" {
            // Сохранить логин пользователя в singleton
            Session.instance.userid = login
        } else {
            print("Ошибка в Логине(\(loginTextInput.text!)) или Пароле(\(passwordTextInput.text!))")
        }
    }
    
    // Кнопка выйти
    @IBAction func logOutVK(unwindSegue: UIStoryboardSegue) { }
    
}

// MARK: - UIViewControllerTransitioningDelegate

// Анимация перехода
extension LoginViewController: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TransitionAnimation(isPresented: true, typeController: .login)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TransitionAnimation(isPresented: false, typeController: .login)
    }
    
}
