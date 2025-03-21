import UIKit
import RealmSwift

// Структура для адаптера
struct User_Swift {
    var id: String
    var FirstName: String
    var LastName: String
    var PhotoFriend: String
}

final class FriendViewController: UITableViewController {

    // MARK: - IBOutlets

    @IBOutlet private var searchButton: UIBarButtonItem!

    // MARK: - Private Properties

    private let alphabet: [Character] = [ "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я", "A", "B", "S", "D", "I", "F", "G", "H", "I", "G", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
    private var friends: [User_Swift] = []
    private var friendsABC: [[User_Swift?]] = []
    private var currentFriends: [[User_Swift?]] = []
    private let searchBar = UISearchBar()
    private var friendToken: NotificationToken?
    private lazy var dataProcessing = DataProcessingService.init(container: self.tableView)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private Methods

private extension FriendViewController {

    func setupView() {
        // Установим Header для таблицы
        let view = UIView()
        view.alpha = 0.6
        view.frame = CGRect(x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: 70)
        self.tableView.tableHeaderView = view
        searchBar.frame = CGRect(x: 50,
                                 y: 10,
                                 width: UIScreen.main.bounds.width-100,
                                 height: 60)
        searchBar.placeholder = "начните поиск"
        searchBar.delegate = self
        view.addSubview(searchBar)
        // Загрузим данные
        loadFriendData()
        // Установим действие кнопки поиска
        searchButton.target = self
        searchButton.action = #selector(searchButtonOnTap)
    }

    // Рассортировать данные по алфавиту
    func filterABC() {
        alphabet.forEach { Char in
            let abc = friends.filter { $0.LastName.first == Char }
            friendsABC.append(abc)
        }
        // Установить текущие значения на начальные
        currentFriends = friendsABC
    }

    // Вернем в начало скрола для поиска
    @objc func searchButtonOnTap() {
        tableView.setContentOffset(.zero, animated: true)
    }

    // Загрузить данные
    func loadFriendData() {
        VKServiceProxy().getFriend() { [weak self] in
            if let error = $0 {
                print(error)
            } else {
                // Загрузить данные из базы
                self?.loadDataFromRealm()
            }
        }
    }

    // Адаптер для перехода с модели Realm на Swift
    func userAdapter(from User: User) -> User_Swift {
        User_Swift(id: User.id,
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
}

// MARK: - SearchBarDelegate

extension FriendViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            // Установить текущие значения на начальные
            currentFriends = friendsABC
        } else {
            currentFriends = []
            friendsABC.forEach {
                let current = $0.filter { $0?.LastName.range(of: searchText, options: .caseInsensitive) != nil }
                currentFriends.append(current)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension FriendViewController {

    // Зададим количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        currentFriends.count
    }

    // Задаем количество строк равное количесву элементов в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentFriends[section].count
    }

    // Создадим Header для каждой ячейки
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .rgbaCache(0.0, 122.0, 255.0, 1.0)
        let lable = UILabel(frame: CGRect(x: 20,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: 30))
        lable.textColor = .rgbaCache(255.0, 50.0, 50.0, 1.0)
        lable.text = "\(alphabet[section])"
        view.addSubview(lable)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        currentFriends[section].count > 0 ? 30 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        // Удостоверимся что значение есть
        if let friends = currentFriends[indexPath.section][indexPath.row] {
            // Заполним ячейку каждой секции полученными данными
            cell.fillCell(friends, indexPath, dataProcessing)
        }
        // Установим действия в ячейку
        cell.setupAction()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Session.instance.photoUserId = currentFriends[indexPath.section][indexPath.row]?.id
    }
}
