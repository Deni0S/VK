//
//  FriendVC.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import RealmSwift

class FriendVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchButton: UIBarButtonItem!
    private var searchBar = UISearchBar()
    var friends: [User_Swift] = []
    var friendToken: NotificationToken?
    var searchFriends: [User_Swift] = [User_Swift]()
    var friends0: [User_Swift] = []
    var friends1: [User_Swift] = []
    var friends2: [User_Swift] = []
    var friends3: [User_Swift] = []
    var friends4: [User_Swift] = []
    var friends5: [User_Swift] = []
    var friends6: [User_Swift] = []
    var friends7: [User_Swift] = []
    var friends8: [User_Swift] = []
    var friends9: [User_Swift] = []
    var friends10: [User_Swift] = []
    var friends11: [User_Swift] = []
    var friends12: [User_Swift] = []
    var friends13: [User_Swift] = []
    var friends14: [User_Swift] = []
    var friends15: [User_Swift] = []
    var friends16: [User_Swift] = []
    var friends17: [User_Swift] = []
    var friends18: [User_Swift] = []
    var friends19: [User_Swift] = []
    var friends20: [User_Swift] = []
    var friends21: [User_Swift] = []
    var friends22: [User_Swift] = []
    var friends23: [User_Swift] = []
    var friends24: [User_Swift] = []
    var friends25: [User_Swift] = []
    var friends26: [User_Swift] = []
    var friends27: [User_Swift] = []
    var friends28: [User_Swift] = []
    var friends29: [User_Swift] = []
    var friends30: [User_Swift] = []
    var currentFriends0: [User_Swift] = [User_Swift]()
    var currentFriends1: [User_Swift] = [User_Swift]()
    var currentFriends2: [User_Swift] = [User_Swift]()
    var currentFriends3: [User_Swift] = [User_Swift]()
    var currentFriends4: [User_Swift] = [User_Swift]()
    var currentFriends5: [User_Swift] = [User_Swift]()
    var currentFriends6: [User_Swift] = [User_Swift]()
    var currentFriends7: [User_Swift] = [User_Swift]()
    var currentFriends8: [User_Swift] = [User_Swift]()
    var currentFriends9: [User_Swift] = [User_Swift]()
    var currentFriends10: [User_Swift] = [User_Swift]()
    var currentFriends11: [User_Swift] = [User_Swift]()
    var currentFriends12: [User_Swift] = [User_Swift]()
    var currentFriends13: [User_Swift] = [User_Swift]()
    var currentFriends14: [User_Swift] = [User_Swift]()
    var currentFriends15: [User_Swift] = [User_Swift]()
    var currentFriends16: [User_Swift] = [User_Swift]()
    var currentFriends17: [User_Swift] = [User_Swift]()
    var currentFriends18: [User_Swift] = [User_Swift]()
    var currentFriends19: [User_Swift] = [User_Swift]()
    var currentFriends20: [User_Swift] = [User_Swift]()
    var currentFriends21: [User_Swift] = [User_Swift]()
    var currentFriends22: [User_Swift] = [User_Swift]()
    var currentFriends23: [User_Swift] = [User_Swift]()
    var currentFriends24: [User_Swift] = [User_Swift]()
    var currentFriends25: [User_Swift] = [User_Swift]()
    var currentFriends26: [User_Swift] = [User_Swift]()
    var currentFriends27: [User_Swift] = [User_Swift]()
    var currentFriends28: [User_Swift] = [User_Swift]()
    var currentFriends29: [User_Swift] = [User_Swift]()
    var currentFriends30: [User_Swift] = [User_Swift]()
    var dataProcessing: DataProcessingService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установим Header для таблицы
        setupTableHeader()
        // Загрузим данные
        loadFriendData()
        // Установим действие кнопки поиска
        searchButton.target = self
        searchButton.action = #selector(searchButtonOnTap)
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
    }
    
    @objc func searchButtonOnTap() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // Загрузить данные
    func loadFriendData() {
        let service = VKService()
        VKServiceProxy(vkService: service).getFriend() { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadDataFromRealm()
        }
    }
    
    // Адаптер для перехода с модели Realm на Swift
    func userAdapter(from User: User) -> User_Swift {
        return User_Swift(id: User.id,
                          FirstName: User.FirstName,
                          LastName: User.LastName,
                          PhotoFriend: User.PhotoFriend)
    }
    
    // Загрузить данные из Realm и подписаться на изменения Notifocations
    func loadDataFromRealm() {
        let realm = try? Realm()
        // Получить объект и отсортировать по имени
        let friends = realm?.objects(User.self).sorted(byKeyPath: "FirstName")
        // Подписаться на изменения Realm Notifocations
        friendToken = friends?.observe({ changes in
            switch changes {
            case .initial(let results):
                print(results)
                // Переделать results в массив через адаптер
                for friend in Array(results) {
                    self.friends.append(self.userAdapter(from: friend))
                }
                self.filterABC()
                self.setupSearchFriends()
                // Перезагрузить коллекцию
                self.tableView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(deletions, insertions, modifications)
                // Обнулим массив друзей
                self.friends = []
                // Переделать results в массив через адаптер
                for friend in Array(results) {
                    self.friends.append(self.userAdapter(from: friend))
                }
                self.filterABC()
                self.setupSearchFriends()
                // Обновить коллекцию и узнать когда завершиться обновление
                self.tableView?.performBatchUpdates({
                    // Добавились строки
                    self.tableView?.insertRows(at: insertions.map({ IndexPath(item: $0, section: 0) }), with: .automatic)
                    // Удалились строки
                    self.tableView?.deleteRows(at: deletions.map({ IndexPath(item: $0, section: 0) }), with: .automatic)
                    // Изменились строки
                    self.tableView?.reloadRows(at: modifications.map({ IndexPath(item: $0, section: 0) }), with: .automatic)
                })
            case .error(let error):
                print(error)
            }
        })
    }

    // Рассортировать данные по алфавиту
    func filterABC() {
        friends0 = friends.filter { $0.LastName.first == "A" || $0.LastName.first == "A"}
        friends1 = friends.filter { $0.LastName.first == "Б" || $0.LastName.first == "B" }
        friends2 = friends.filter { $0.LastName.first == "В" || $0.LastName.first == "V" || $0.LastName.first == "W" }
        friends3 = friends.filter { $0.LastName.first == "Г" || $0.LastName.first == "G" }
        friends4 = friends.filter { $0.LastName.first == "Д" || $0.LastName.first == "D" || $0.LastName.first == "J" }
        friends5 = friends.filter { $0.LastName.first == "Е" || $0.LastName.first == "E" }
        friends6 = friends.filter { $0.LastName.first == "Ё" }
        friends7 = friends.filter { $0.LastName.first == "Ж" /*$0.LastName[$0.LastName.index($0.LastName.startIndex, offsetBy: 1)] == "h"*/}
        friends8 = friends.filter { $0.LastName.first == "З" || $0.LastName.first == "Z" }
        friends9 = friends.filter { $0.LastName.first == "И" || $0.LastName.first == "I" }
        friends10 = friends.filter { $0.LastName.first == "Й" }
        friends11 = friends.filter { $0.LastName.first == "К" || $0.LastName.first == "K" || $0.LastName.first == "Q" || $0.LastName.first == "X"}
        friends12 = friends.filter { $0.LastName.first == "Л" || $0.LastName.first == "L" }
        friends13 = friends.filter { $0.LastName.first == "М" || $0.LastName.first == "M" }
        friends14 = friends.filter { $0.LastName.first == "Н" || $0.LastName.first == "N" }
        friends15 = friends.filter { $0.LastName.first == "О" || $0.LastName.first == "O" }
        friends16 = friends.filter { $0.LastName.first == "П" || $0.LastName.first == "P" }
        friends17 = friends.filter { $0.LastName.first == "Р" || $0.LastName.first == "R" }
        friends18 = friends.filter { $0.LastName.first == "С" || $0.LastName.first == "S" }
        friends19 = friends.filter { $0.LastName.first == "Т" || $0.LastName.first == "T" }
        friends20 = friends.filter { $0.LastName.first == "У" || $0.LastName.first == "U" }
        friends21 = friends.filter { $0.LastName.first == "Ф" || $0.LastName.first == "F" }
        friends22 = friends.filter { $0.LastName.first == "Х" || $0.LastName.first == "H" }
        friends23 = friends.filter { $0.LastName.first == "Ц" }
        friends24 = friends.filter { $0.LastName.first == "Ч" }
        friends25 = friends.filter { $0.LastName.first == "Ш" }
        friends26 = friends.filter { $0.LastName.first == "Щ" }
        friends27 = friends.filter { $0.LastName.first == "Ы" }
        friends28 = friends.filter { $0.LastName.first == "Э" }
        friends29 = friends.filter { $0.LastName.first == "Ю" || $0.LastName.first == "Y" }
        friends30 = friends.filter { $0.LastName.first == "Я" || $0.LastName.first == "Y" }
    }

    // Установить текущие значения на начальные
    func setupSearchFriends() {
        currentFriends0 = friends0
        currentFriends1 = friends1
        currentFriends2 = friends2
        currentFriends3 = friends3
        currentFriends4 = friends4
        currentFriends5 = friends5
        currentFriends6 = friends6
        currentFriends7 = friends7
        currentFriends8 = friends8
        currentFriends9 = friends9
        currentFriends10 = friends10
        currentFriends11 = friends11
        currentFriends12 = friends12
        currentFriends13 = friends13
        currentFriends14 = friends14
        currentFriends15 = friends15
        currentFriends16 = friends16
        currentFriends17 = friends17
        currentFriends18 = friends18
        currentFriends19 = friends19
        currentFriends20 = friends20
        currentFriends21 = friends21
        currentFriends22 = friends22
        currentFriends23 = friends23
        currentFriends24 = friends24
        currentFriends25 = friends25
        currentFriends26 = friends26
        currentFriends27 = friends27
        currentFriends28 = friends28
        currentFriends29 = friends29
        currentFriends30 = friends30
    }
    
    // Установить Header для таблицы
    func setupTableHeader() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        self.tableView.tableHeaderView = view
        searchBar.frame = CGRect(x: 50, y: 10, width: UIScreen.main.bounds.width-100, height: 30)
        searchBar.placeholder = "начните поиск"
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            setupSearchFriends()
        } else {
            currentFriends0 = friends0.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends1 = friends1.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends2 = friends2.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends3 = friends3.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends4 = friends4.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends5 = friends5.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends6 = friends6.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends7 = friends7.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends8 = friends8.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends9 = friends9.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends10 = friends10.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends11 = friends11.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends12 = friends12.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends13 = friends13.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends14 = friends14.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends15 = friends15.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends16 = friends16.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends17 = friends17.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends18 = friends18.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends19 = friends19.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends20 = friends20.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends21 = friends21.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends22 = friends22.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends23 = friends23.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends24 = friends24.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends25 = friends25.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends26 = friends26.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends27 = friends27.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends28 = friends28.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends29 = friends29.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
            currentFriends30 = friends30.filter { $0.LastName.range(of: searchText, options: .caseInsensitive) != nil }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // Зададим количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentFriends0.count
        case 1:
            return currentFriends1.count
        case 2:
            return currentFriends2.count
        case 3:
            return currentFriends3.count
        case 4:
            return currentFriends4.count
        case 5:
            return currentFriends5.count
        case 6:
            return currentFriends6.count
        case 7:
            return currentFriends7.count
        case 8:
            return currentFriends8.count
        case 9:
            return currentFriends9.count
        case 10:
            return currentFriends10.count
        case 11:
            return currentFriends11.count
        case 12:
            return currentFriends12.count
        case 13:
            return currentFriends13.count
        case 14:
            return currentFriends14.count
        case 15:
            return currentFriends15.count
        case 16:
            return currentFriends16.count
        case 17:
            return currentFriends17.count
        case 18:
            return currentFriends18.count
        case 19:
            return currentFriends19.count
        case 20:
            return currentFriends20.count
        case 21:
            return currentFriends21.count
        case 22:
            return currentFriends22.count
        case 23:
            return currentFriends23.count
        case 24:
            return currentFriends24.count
        case 25:
            return currentFriends25.count
        case 26:
            return currentFriends26.count
        case 27:
            return currentFriends27.count
        case 28:
            return currentFriends28.count
        case 29:
            return currentFriends29.count
        case 30:
            return currentFriends30.count
        default:
            return 0
        }
    }
    
    // Создадим Header для каждой ячейки
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .rgba(128.0, 128.0, 128.0, a: 1)
        view.alpha = 0.5
        let lable = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: 24))
        switch section {
        case 0:
            lable.text = "А"
        case 1:
            lable.text = "Б"
        case 2:
            lable.text = "В"
        case 3:
            lable.text = "Г"
        case 4:
            lable.text = "Д"
        case 5:
            lable.text = "Е"
        case 6:
            lable.text = "Ё"
        case 7:
            lable.text = "Ж"
        case 8:
            lable.text = "З"
        case 9:
            lable.text = "И"
        case 10:
            lable.text = "Ӣ"
        case 11:
            lable.text = "К"
        case 12:
            lable.text = "Л"
        case 13:
            lable.text = "М"
        case 14:
            lable.text = "Н"
        case 15:
            lable.text = "О"
        case 16:
            lable.text = "П"
        case 17:
            lable.text = "Р"
        case 18:
            lable.text = "С"
        case 19:
            lable.text = "Т"
        case 20:
            lable.text = "У"
        case 21:
            lable.text = "Ф"
        case 22:
            lable.text = "Х"
        case 23:
            lable.text = "Ц"
        case 24:
            lable.text = "Ч"
        case 25:
            lable.text = "Ш"
        case 26:
            lable.text = "Щ"
        case 27:
            lable.text = "Ы"
        case 28:
            lable.text = "Э"
        case 29:
            lable.text = "Ю"
        case 30:
            lable.text = "Я"
        default:
            lable.text = ""
        }
        view.addSubview(lable)
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        // Заполнить ячейку каждой секции полученными данными
        switch indexPath.section {
        case 0:
            cell.fillCell(currentFriends0[indexPath.row], indexPath, dataProcessing!)
        case 1:
            cell.fillCell(currentFriends1[indexPath.row], indexPath, dataProcessing!)
        case 2:
            cell.fillCell(currentFriends2[indexPath.row], indexPath, dataProcessing!)
        case 3:
            cell.fillCell(currentFriends3[indexPath.row], indexPath, dataProcessing!)
        case 4:
            cell.fillCell(currentFriends4[indexPath.row], indexPath, dataProcessing!)
        case 5:
            cell.fillCell(currentFriends5[indexPath.row], indexPath, dataProcessing!)
        case 6:
            cell.fillCell(currentFriends6[indexPath.row], indexPath, dataProcessing!)
        case 7:
            cell.fillCell(currentFriends7[indexPath.row], indexPath, dataProcessing!)
        case 8:
            cell.fillCell(currentFriends8[indexPath.row], indexPath, dataProcessing!)
        case 9:
            cell.fillCell(currentFriends9[indexPath.row], indexPath, dataProcessing!)
        case 10:
            cell.fillCell(currentFriends10[indexPath.row], indexPath, dataProcessing!)
        case 11:
            cell.fillCell(currentFriends11[indexPath.row], indexPath, dataProcessing!)
        case 12:
            cell.fillCell(currentFriends12[indexPath.row], indexPath, dataProcessing!)
        case 13:
            cell.fillCell(currentFriends13[indexPath.row], indexPath, dataProcessing!)
        case 14:
            cell.fillCell(currentFriends14[indexPath.row], indexPath, dataProcessing!)
        case 15:
            cell.fillCell(currentFriends15[indexPath.row], indexPath, dataProcessing!)
        case 16:
           cell.fillCell(currentFriends16[indexPath.row], indexPath, dataProcessing!)
        case 17:
            cell.fillCell(currentFriends17[indexPath.row], indexPath, dataProcessing!)
        case 18:
            cell.fillCell(currentFriends18[indexPath.row], indexPath, dataProcessing!)
        case 19:
            cell.fillCell(currentFriends19[indexPath.row], indexPath, dataProcessing!)
        case 20:
            cell.fillCell(currentFriends20[indexPath.row], indexPath, dataProcessing!)
        case 21:
            cell.fillCell(currentFriends21[indexPath.row], indexPath, dataProcessing!)
        case 22:
            cell.fillCell(currentFriends22[indexPath.row], indexPath, dataProcessing!)
        case 23:
            cell.fillCell(currentFriends23[indexPath.row], indexPath, dataProcessing!)
        case 24:
            cell.fillCell(currentFriends24[indexPath.row], indexPath, dataProcessing!)
        case 25:
            cell.fillCell(currentFriends25[indexPath.row], indexPath, dataProcessing!)
        case 26:
            cell.fillCell(currentFriends26[indexPath.row], indexPath, dataProcessing!)
        case 27:
            cell.fillCell(currentFriends27[indexPath.row], indexPath, dataProcessing!)
        case 28:
            cell.fillCell(currentFriends28[indexPath.row], indexPath, dataProcessing!)
        case 29:
            cell.fillCell(currentFriends29[indexPath.row], indexPath, dataProcessing!)
        case 30:
            cell.fillCell(currentFriends30[indexPath.row], indexPath, dataProcessing!)
        default:
            cell.fillCell(searchFriends[indexPath.row], indexPath, dataProcessing!)
        }
        // Установить действия в ячейку
        cell.setupAction()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            Session.instance.photoUserId = currentFriends0[indexPath.row].id
        case 1:
            Session.instance.photoUserId = currentFriends1[indexPath.row].id
        case 2:
            Session.instance.photoUserId = currentFriends2[indexPath.row].id
        case 3:
            Session.instance.photoUserId = currentFriends3[indexPath.row].id
        case 4:
            Session.instance.photoUserId = currentFriends4[indexPath.row].id
        case 5:
            Session.instance.photoUserId = currentFriends5[indexPath.row].id
        case 6:
            Session.instance.photoUserId = currentFriends6[indexPath.row].id
        case 7:
            Session.instance.photoUserId = currentFriends7[indexPath.row].id
        case 8:
            Session.instance.photoUserId = currentFriends8[indexPath.row].id
        case 9:
            Session.instance.photoUserId = currentFriends9[indexPath.row].id
        case 10:
            Session.instance.photoUserId = currentFriends10[indexPath.row].id
        case 11:
            Session.instance.photoUserId = currentFriends11[indexPath.row].id
        case 12:
            Session.instance.photoUserId = currentFriends12[indexPath.row].id
        case 13:
            Session.instance.photoUserId = currentFriends13[indexPath.row].id
        case 14:
            Session.instance.photoUserId = currentFriends14[indexPath.row].id
        case 15:
            Session.instance.photoUserId = currentFriends15[indexPath.row].id
        case 16:
            Session.instance.photoUserId = currentFriends16[indexPath.row].id
        case 17:
            Session.instance.photoUserId = currentFriends17[indexPath.row].id
        case 18:
            Session.instance.photoUserId = currentFriends18[indexPath.row].id
        case 19:
            Session.instance.photoUserId = currentFriends19[indexPath.row].id
        case 20:
            Session.instance.photoUserId = currentFriends20[indexPath.row].id
        case 21:
            Session.instance.photoUserId = currentFriends21[indexPath.row].id
        case 22:
            Session.instance.photoUserId = currentFriends22[indexPath.row].id
        case 23:
            Session.instance.photoUserId = currentFriends23[indexPath.row].id
        case 24:
            Session.instance.photoUserId = currentFriends24[indexPath.row].id
        case 25:
            Session.instance.photoUserId = currentFriends25[indexPath.row].id
        case 26:
            Session.instance.photoUserId = currentFriends26[indexPath.row].id
        case 27:
            Session.instance.photoUserId = currentFriends27[indexPath.row].id
        case 28:
            Session.instance.photoUserId = currentFriends28[indexPath.row].id
        case 29:
            Session.instance.photoUserId = currentFriends29[indexPath.row].id
        case 30:
            Session.instance.photoUserId = currentFriends30[indexPath.row].id
        default:
            Session.instance.photoUserId = friends[indexPath.row].id
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
