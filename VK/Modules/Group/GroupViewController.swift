import UIKit
import RealmSwift

final class GroupViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private var groups: [Group] = []
    private var groupToken: NotificationToken?
    private var dataProcessing: DataProcessingService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        // Загрузим данные
        loadGroupData()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
    }
    
}

// MARK: - Private Methods

private extension GroupViewController {

    // Загрузить данные
    func loadGroupData () {
        VKServiceProxy().getGroup() { [weak self] error in
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
            let groupSearchVC = segue.source as! GroupSearchViewController
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
    
}

// MARK: - Table view data source

extension GroupViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { groups.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        // Получаем имя группы для конкретной строки
        let group = groups[indexPath.row]
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(group, indexPath, dataProcessing!)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка удалить
        if editingStyle == .delete {
            // Удаляем группу из массива
            groups.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
