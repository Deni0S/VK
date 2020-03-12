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
    var friends: [User] = []
    var searchFriends: [User] = [User]()
    var friends0: [User] = []
    var friends1: [User] = []
    var friends2: [User] = []
    var friends3: [User] = []
    var friends4: [User] = []
    var friends5: [User] = []
    var friends6: [User] = []
    var friends7: [User] = []
    var friends8: [User] = []
    var friends9: [User] = []
    var friends10: [User] = []
    var friends11: [User] = []
    var friends12: [User] = []
    var friends13: [User] = []
    var friends14: [User] = []
    var friends15: [User] = []
    var friends16: [User] = []
    var friends17: [User] = []
    var friends18: [User] = []
    var friends19: [User] = []
    var friends20: [User] = []
    var friends21: [User] = []
    var friends22: [User] = []
    var friends23: [User] = []
    var friends24: [User] = []
    var friends25: [User] = []
    var friends26: [User] = []
    var friends27: [User] = []
    var friends28: [User] = []
    var friends29: [User] = []
    var friends30: [User] = []
    var currentFriends0: [User] = [User]()
    var currentFriends1: [User] = [User]()
    var currentFriends2: [User] = [User]()
    var currentFriends3: [User] = [User]()
    var currentFriends4: [User] = [User]()
    var currentFriends5: [User] = [User]()
    var currentFriends6: [User] = [User]()
    var currentFriends7: [User] = [User]()
    var currentFriends8: [User] = [User]()
    var currentFriends9: [User] = [User]()
    var currentFriends10: [User] = [User]()
    var currentFriends11: [User] = [User]()
    var currentFriends12: [User] = [User]()
    var currentFriends13: [User] = [User]()
    var currentFriends14: [User] = [User]()
    var currentFriends15: [User] = [User]()
    var currentFriends16: [User] = [User]()
    var currentFriends17: [User] = [User]()
    var currentFriends18: [User] = [User]()
    var currentFriends19: [User] = [User]()
    var currentFriends20: [User] = [User]()
    var currentFriends21: [User] = [User]()
    var currentFriends22: [User] = [User]()
    var currentFriends23: [User] = [User]()
    var currentFriends24: [User] = [User]()
    var currentFriends25: [User] = [User]()
    var currentFriends26: [User] = [User]()
    var currentFriends27: [User] = [User]()
    var currentFriends28: [User] = [User]()
    var currentFriends29: [User] = [User]()
    var currentFriends30: [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установим Header для таблицы
        setupTableHeader()
        // Загрузим данные
        loadFriendData()
        // Установим действие кнопки поиска
        searchButton.target = self
        searchButton.action = #selector(searchButtonOnTap)
    }
    
    @objc func searchButtonOnTap() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // Загрузить данные
    func loadFriendData() {
        let service = VKService()
        service.getFriend() { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadDataFromRealm()
        }
    }
    
    // Загрузить данные из Realm
    func loadDataFromRealm() {
        let realm = try! Realm()
        // Получить объект
        let friends = realm.objects(User.self)
        // Переделать results в массив
        self.friends = Array(friends)
        self.filterABC()
        self.setupSearchFriends()
        self.tableView?.reloadData()
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
        view.backgroundColor = .gray
        view.alpha = 0.5
        var lable = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: 24))
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
            cell.fillCell(currentFriends0[indexPath.row])
        case 1:
            cell.fillCell(currentFriends1[indexPath.row])
        case 2:
            cell.fillCell(currentFriends2[indexPath.row])
        case 3:
            cell.fillCell(currentFriends3[indexPath.row])
        case 4:
            cell.fillCell(currentFriends4[indexPath.row])
        case 5:
            cell.fillCell(currentFriends5[indexPath.row])
        case 6:
            cell.fillCell(currentFriends6[indexPath.row])
        case 7:
            cell.fillCell(currentFriends7[indexPath.row])
        case 8:
            cell.fillCell(currentFriends8[indexPath.row])
        case 9:
            cell.fillCell(currentFriends9[indexPath.row])
        case 10:
            cell.fillCell(currentFriends10[indexPath.row])
        case 11:
            cell.fillCell(currentFriends11[indexPath.row])
        case 12:
            cell.fillCell(currentFriends12[indexPath.row])
        case 13:
            cell.fillCell(currentFriends13[indexPath.row])
        case 14:
            cell.fillCell(currentFriends14[indexPath.row])
        case 15:
            cell.fillCell(currentFriends15[indexPath.row])
        case 16:
           cell.fillCell(currentFriends16[indexPath.row])
        case 17:
            cell.fillCell(currentFriends17[indexPath.row])
        case 18:
            cell.fillCell(currentFriends18[indexPath.row])
        case 19:
            cell.fillCell(currentFriends19[indexPath.row])
        case 20:
            cell.fillCell(currentFriends20[indexPath.row])
        case 21:
            cell.fillCell(currentFriends21[indexPath.row])
        case 22:
            cell.fillCell(currentFriends22[indexPath.row])
        case 23:
            cell.fillCell(currentFriends23[indexPath.row])
        case 24:
            cell.fillCell(currentFriends24[indexPath.row])
        case 25:
            cell.fillCell(currentFriends25[indexPath.row])
        case 26:
            cell.fillCell(currentFriends26[indexPath.row])
        case 27:
            cell.fillCell(currentFriends27[indexPath.row])
        case 28:
            cell.fillCell(currentFriends28[indexPath.row])
        case 29:
            cell.fillCell(currentFriends29[indexPath.row])
        case 30:
            cell.fillCell(currentFriends30[indexPath.row])
        default:
            cell.fillCell(searchFriends[indexPath.row])
        }
        // Установить действия в ячейку
        cell.setupAction()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Session.instance.photoUserId = friends[indexPath.row].id
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
