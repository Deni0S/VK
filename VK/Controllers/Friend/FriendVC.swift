//
//  FriendVC.swift
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class FriendVC: UITableViewController, UISearchBarDelegate {
    private var searchBar = UISearchBar()
    
    var friendsA = [
        "Петр Амбросьев",
        "Григорий Афанасьев",
        "Семен Ачаев"
    ]
    
    var friendsL = [
        "Михаил Лаврентьев",
        "Валентин Литкин",
    ]
    
    var friendsM = [
        "Виктор Мартынов"
    ]
    
    var searchFriendsA: [String] = [String]()
    var searchFriendsL: [String] = [String]()
    var searchFriendsM: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableHeader()
        searchFriendsA = friendsA
        searchFriendsL = friendsL
        searchFriendsM = friendsM
    }

    // Установить Header для таблицы
    func setupTableHeader () {
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
            searchFriendsA = friendsA
            searchFriendsL = friendsL
            searchFriendsM = friendsM
        } else {
            searchFriendsA = friendsA.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
            searchFriendsL = friendsL.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
            searchFriendsM = friendsM.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // Зададим количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return searchFriendsA.count
        case 1:
            return searchFriendsL.count
        case 2:
            return searchFriendsM.count
        default:
            return 0
        }
    }
    
    // Создадим Header для каждой ячейки
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.5
        let lable = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: 24))
        view.addSubview(lable)
        switch section {
        case 0:
            lable.text = "А"
        case 1:
            lable.text = "Л"
        case 2:
            lable.text = "М"
        default:
            lable.text = ""
        }
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        // Получаем имя друга для конкретной строки и секции
        var friend = ""
        switch indexPath.section {
        case 0:
            friend = searchFriendsA[indexPath.row]
        case 1:
            friend = searchFriendsL[indexPath.row]
        case 2:
            friend = searchFriendsM[indexPath.row]
        default:
            friend = ""
        }
        // Устанавливаем имя в надпись ячейки
        cell.friendName?.text = friend
        return cell
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
