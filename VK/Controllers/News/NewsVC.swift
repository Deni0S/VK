//
//  NewsVC.swift
//  VK
//
//  Created by Денис Баринов on 9.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsVC: UITableViewController {
    var news: [News] = []
    let session = Session.instance
    var newsTokenRealm: NotificationToken?
    var dataProcessing: DataProcessingService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Загрузить данные
        loadNewsData()
    }
    
    // Загрузить данные
    func loadNewsData() {
        let service = VKService()
        service.getNews() { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadNewsFromRealm()
        }
    }
    
    // Загрузить данные из Realm и подписаться на изменения Notifocations
    func loadNewsFromRealm() {
        let realm = try! Realm()
        // Получить объекты и отсортировать по дате
        let news = realm.objects(News.self).sorted(byKeyPath: "Date", ascending: false)
        // Подписаться на изменения Realm Notofocations
        newsTokenRealm = news.observe({ changes in
            switch changes {
            case .initial(let results):
//                print(results)
                // Переделать results  в массив
                self.news = Array(results)
                // Перезагрузить таблицу
                self.tableView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
//                print(deletions, insertions, modifications)
                // Переделать results  в массив
                self.news = Array(results)
                // Обновить таблицу и узнать когда завершиться обновление
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = NewsCell()
        // Получаем ячейку из пула
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellPost", for: indexPath) as! NewsCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellPhoto", for: indexPath) as! NewsCell
        }
        // Заполнить ячейку
        cell.fillCell(news[indexPath.row], indexPath, dataProcessing!)
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
