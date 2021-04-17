import UIKit
import Realm

final class GroupSearchViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var searchBar: UISearchBar!
    
    // MARK: - Public Properties
    
    public var groupsSearch: [Group] = []
    
    // MARK: - Private Properties
    
    private var dataProcessing: DataProcessingService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        searchBar.placeholder = "начните поиск групп на английском"
        searchBar.delegate = self
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
    }

}

// MARK: - UISearchBarDelegate

extension GroupSearchViewController: UISearchBarDelegate {
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        VKServiceProxy().getGroupSearch(search: searchText) { [weak self] groupsSearch, error in
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
    
}

// MARK: - Table view data source

extension GroupSearchViewController {
    
    // Задаем количество секций
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { groupsSearch.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSearchCell", for: indexPath) as! GroupSearchCell
        // Получаем имя группы для конкретной строки
        let groupSearch = groupsSearch[indexPath.row]
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(groupSearch, indexPath, dataProcessing!)
        return cell
    }
    
}
