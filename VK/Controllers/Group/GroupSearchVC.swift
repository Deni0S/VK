//
//  GroupSearchVC.swift
//  VK
//
//  Created by Денис Баринов on 21.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupSearchVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var groupsSearch: [Group] = []
    let service = VKService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        searchBar.placeholder = "начните поиск групп на английском"
        searchBar.delegate = self
    }

    // MARK: - Search Bar Delegate
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        service.getGroupSearch(search: searchText) { [weak self] groupsSearch, error in
            if let error = error {
                print(error)
                return
            }
            if let groupsSearch = groupsSearch {
                self?.groupsSearch = groupsSearch
                self?.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsSearch.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSearchCell", for: indexPath) as! GroupSearchCell
        // Получаем имя группы для конкретной строки
        let groupSearch = groupsSearch[indexPath.row]
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(groupSearch)
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
