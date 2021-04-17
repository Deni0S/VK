import UIKit
import RealmSwift

struct NewsViewModel {
    let Avatar: String
    let Name: String
    let Date: Double
    let Photo: String
    let TextNews: String
    let Likes: String
    let Comments: String
    let Reposts: String
    let Views: String
}

final class NewsViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private let session = Session.instance
    private var newsTokenRealm: NotificationToken?
    private var dataProcessing: DataProcessingService?
    private var isLoading = false
    private let viewModelFactory = NewsViewModelFactory()
    private var viewModel: [NewsViewModel] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Загрузить данные
        loadNewsData()
        // Установить refresh сontrol
        setupRefreshControl()
    }
    
}

// MARK: - Private Methods

private extension NewsViewController {
    
    func setupView() {
        self.tableView.tableFooterView = UIView()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.tableView)
        // Назначаем себя делегатом Data Source
        self.tableView.prefetchDataSource = self
    }
    
    // Загрузить данные
    func loadNewsData(isRefresh: Bool = false) {
        // Убеждаемся что мы не в процессе загрузки данных
        if isLoading != true {
            VKServiceProxy().getNews(isRefresh: isRefresh) { [weak self] in
                if let error = $0 {
                    print(error)
                } else {
                    // Загрузить данные из базы
                    self?.loadNewsFromRealm()
                    // Выключаем статус загрузки данных
                    self?.isLoading = false
                }
            }
        }
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загружаю новости")
        refreshControl?.tintColor = .rgbaCache(128.0, 128.0, 128.0, 1.0)
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    // Обновить новости
    @objc func refreshNews() {
        refreshControl?.beginRefreshing()
        VKServiceProxy().getNews(dateLastNews: self.viewModel.first?.Date, isRefresh: true) { [weak self] error in
            guard self != nil else {
                print(error as Any)
                return
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    // Загрузить данные из Realm и подписаться на изменения Notifocations
    func loadNewsFromRealm() {
        let realm = try! Realm()
        // Получить объекты и отсортировать по дате
        let news = realm.objects(News.self).sorted(byKeyPath: "Date",
                                                   ascending: false)
        // Подписаться на изменения Realm Notofocations
        newsTokenRealm = news.observe({ changes in
            switch changes {
            case .initial(let results):
                print(results)
                // Сконструируем view Model из results
                self.viewModel = self.viewModelFactory.constructViewModel(from: Array(results))
                // Перезагрузить таблицу
                self.tableView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(deletions, insertions, modifications)
                // Сконструируем view Model
                self.viewModel = self.viewModelFactory.constructViewModel(from: Array(results))
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
    
}

// MARK: - Table view data source
    
extension NewsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = NewsCell()
        // Получаем ячейку из пула
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellPost", for: indexPath) as! NewsCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellPhoto", for: indexPath) as! NewsCell
        }
        // Заполнить ячейку
        cell.fillCellFactory(with: viewModel[indexPath.row], indexPath, dataProcessing!)
        return cell
    }
    
    // TODO: Доделать авторазмер под фотографию
    
}

// MARK: - UITableViewDataSourcePrefetching

extension NewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Выбираем максимальный номер отбражаемой секции
        print(indexPaths)
        guard let maxSection = indexPaths.map ({ $0.row }).max() else { return }
        print(maxSection)
        // Проверим входит ли она в три последние
        if maxSection > viewModel.count - 3, !isLoading {
            loadNewsData(isRefresh: true)
        }
    }
    
}
