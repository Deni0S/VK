//
//  GroupVC.swift
//  VK
//
//  Created by Денис Баринов on 21.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupVC: UITableViewController {
    var groups: [Group] = []
    var groupToken: NotificationToken?
    var dataProcessing: DataProcessingService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Загрузим данные
        loadGroupData()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
    }
    
    // Загрузить данные
    func loadGroupData () {
        let service = VKService()
        VKServiceProxy(vkService: service).getGroup() { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadDataFromRealm()
        }
    }
    
    // Загрузить данные из Realm и подписаться на изменения Notifocations
    func loadDataFromRealm() {
        let realm = try! Realm()
        // Получить объект и отсортировать по имени
        let groups = realm.objects(Group.self).sorted(byKeyPath: "Name")
        // Подписаться на изменения Realm Notifocations
        groupToken = groups.observe({ changes in
            switch changes {
            case .initial(let results):
                print(results)
                // Переделать results  в массив
                self.groups = Array(results)
                // Перезагрузить коллекцию
                self.tableView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(deletions, insertions, modifications)
                // Переделать results  в массив
                self.groups = Array(results)
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

    // Создадим обратный переход при добавлении групп
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверим тот ли переход по идентификатору
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер с которого переходим
            let groupSearchVC = segue.source as! GroupSearchVC
            // Получаем индекс выделенной ячейки
            if let indexPath = groupSearchVC.tableView.indexPathForSelectedRow {
                // Получаем группу по инедексу
                let groupSearch = groupSearchVC.groupsSearch[indexPath.row]
                // Проверяем что такой группы нет в списке
                if !groups.contains(groupSearch) {
                    // Добавляем группу в список
                    groups.append(groupSearch)
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        // Получаем имя группы для конкретной строки
        let group = groups[indexPath.row]
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(group, indexPath, dataProcessing!)
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка удалить
        if editingStyle == .delete {
            // Удаляем группу из массива
            groups.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        //} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
