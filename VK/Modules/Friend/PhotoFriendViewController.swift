import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

final class PhotoFriendViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    
    private var photos: [Photo] = []
    private var photoToken: NotificationToken?
    private var buttons: [UIButton] = []
    private var dataProcessing: DataProcessingService?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Загрузим данные
        loadFriendData()
        // Проинициализируем сервис обработки данных
        dataProcessing = DataProcessingService.init(container: self.collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let fullPhotoVC = segue.destination as? FullPhotoViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            fullPhotoVC.photos = photos
            fullPhotoVC.indexPath = indexPath.row
        }
    }
    
}

// MARK: - Private Methods

private extension PhotoFriendViewController {
    
    // Загрузить данные
    func loadFriendData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            VKServiceProxy().getPhoto(id: Session.instance.photoUserId) { [weak self] in
                if let error = $0 {
                    print(error)
                } else {
                    // Загрузить данные из базы
                    self?.loadDataFromRealm()
                }
            }
            Session.instance.photoUserId = nil
        }
    }
    
    // Загрузить данные из Realm и подписаться на изменения Notifocations
    func loadDataFromRealm() {
        let realm = try! Realm()
        // Получить объект и отсортировать по алфовиту
        let photos = realm.objects(Photo.self).sorted(byKeyPath: "text")
        // Подписаться на изменения Realm Notifocations
        photoToken = photos.observe({ changes in
            switch changes {
            case .initial(let results):
                print(results)
                // Переделать results  в массив
                self.photos = Array(results)
                // Перезагрузить коллекцию
                self.collectionView?.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(deletions, insertions, modifications)
                // Переделать results  в массив
                self.photos = Array(results)
                // Обновить коллекцию и узнать когда завершиться обновление
                self.collectionView?.performBatchUpdates({
                    // Добавились секции
                    self.collectionView?.insertItems(at: insertions.map({ IndexPath(item: $0, section: 0) }) )
                    // Удалились секции
                    self.collectionView?.deleteItems(at: deletions.map({ IndexPath(item: $0, section: 0) }) )
                    // Изменились секции
                    self.collectionView?.reloadItems(at: modifications.map({ IndexPath(item: $0, section: 0) }) )
                })
            case .error(let error):
                print(error)
            }
        })
    }
    
}

// MARK: - UICollectionViewDataSource

extension PhotoFriendViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { photos.count }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendCell", for: indexPath) as! PhotoFriendCell
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(photos[indexPath.row],
                      indexPath, dataProcessing!)
        return cell
    }

}
