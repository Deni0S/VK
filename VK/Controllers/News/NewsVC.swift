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
    let service = VKService()
    var news: [News] = []
    let session = Session.instance
    var newsTokenRealm: NotificationToken?
    var dataProcessing: DataProcessingService?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
        // Назначаем себя делегатом Data Source
        self.tableView.prefetchDataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Загрузить данные
        loadNewsData()
        // Установить refresh сontrol
        setupRefreshControl()
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загружаю новости")
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    // Обновить новости
    @objc func refreshNews() {
        refreshControl?.beginRefreshing()
        service.getNews(dateLastNews: self.news.first?.Date, isRefresh: true) { [weak self] error in
            guard self != nil else {
                print(error as Any)
                return
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    // Загрузить данные
    func loadNewsData(isRefresh: Bool = false) {
        // Убеждаемся что мы не в процессе загрузки данных
        isLoading = true
        service.getNews(isRefresh: isRefresh) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadNewsFromRealm()
            // Выключаем статус загрузки данных
            self?.isLoading = false
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
                print(results)
                // Переделать results  в массив
                self.news = Array(results)
                // Перезагрузить таблицу
                self.tableView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(deletions, insertions, modifications)
                // Переделать results  в массив
                self.news = Array(results)
                // Обновить таблицу и узнать когда завершиться обновление
                self.tableView?.performBatchUpdates({
                    // Добавились строки
                    self.tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    // Удалились строки
                    self.tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    // Изменились строки
                    self.tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                })
            case .error(let error):
                print(error)
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
    
    // TODO: Доделать авторазмер под фотографию
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let height: CGFloat = CGFloat(news[indexPath.row].PhotoHeight), let width: CGFloat = CGFloat(news[indexPath.row].PhotoWidth) else { return UITableView.automaticDimension }
//        let heightRow = height / width * tableView.bounds.width
//        return heightRow
//    }
    
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

extension NewsVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Выбираем максимальный номер отбражаемой секции
        print(indexPaths)
        guard let maxSection = indexPaths.map ({ $0.row }).max() else { return }
        print(maxSection)
        // Проверим входит ли она в три последние
        if maxSection > news.count - 3, !isLoading {
            loadNewsData(isRefresh: true)
        }
    }
}
