import Foundation
import Alamofire

// Сервис обработки данных
final class DataProcessingService {
    
    private let casheLifeTime: TimeInterval = 2 * 24 * 60 * 60
    // Словарь с изображениями в кэше для оперативной памяти
    private var images = [String: UIImage] ()
    // Словарь с датой в кэше для оперативной памяти
    var dateTextCache: [IndexPath: String] = [:]
    
    // Преобразовать дату в установленый формат
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }
    
    // Кешировать дату
    func getDateText(forIndexPath indexPath: IndexPath, andTimestemp timestamp: Double) -> String {
        if let stringDate = dateTextCache[indexPath] {
            return stringDate
        } else {
            let date = Date(timeIntervalSince1970: timestamp)
            let stringDate = dateFormatter.string(from: date)
            dateTextCache[indexPath] = stringDate
            return stringDate
        }
    }
    
    // Статические свойства папки
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else {
            return pathName
        }
        let url = cachesDirectory.appendingPathComponent(pathName,
                                                         isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        return pathName
    } ()
    
    // Получить путь к файлу на основе URL
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else {
            return nil
        }
        let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(DataProcessingService.pathName + "/" + hasheName).path
    }
    
    // Сохранить изображение в файловой системе
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url) else { return }
        let data = image.pngData()
        FileManager.default.createFile(atPath: fileName,
                                       contents: data,
                                       attributes: nil)
    }
    
    // Загрузить изображение из файловой системы
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard lifeTime <= casheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        images[url] = image
        return image
    }
    
    // Загрузить фото из сети
    private func loadPhoto(atIndexpath indexPath: IndexPath, byUrl url: String) {
        AF.request(url).responseData() { [weak self] response in
            guard let data = response.data,
                  let image = UIImage(data: data) else { return }
            self?.images[url] = image
            self? .saveImageToCache(url: url,
                                    image: image)
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexpath: indexPath)
            }
        }
    }
    
    // Предоставить изображение по url
    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        // Искать изображение в кэше оперативной памяти
        if let photo = images[url] {
            image = photo
        // Искать Изображение в кэше файловой системы
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        // Загрузить изображение из сети
        } else {
            loadPhoto(atIndexpath: indexPath,
                      byUrl: url)
        }
        return image
    }
    
    private let container: DataReloadable
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
}

// MARK: - DataReloadable

fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath index: IndexPath)
}

private extension DataProcessingService {
    
    class Table: DataReloadable {
        let table: UITableView
        init(table: UITableView) {
            self.table = table
        }
        func reloadRow(atIndexpath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath],
                             with: .none)
        }
    }
    
    class Collection: DataReloadable {
        let collection: UICollectionView
        init(collection: UICollectionView) {
            self.collection = collection
        }
        func reloadRow(atIndexpath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
    
}
