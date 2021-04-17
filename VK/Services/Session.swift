import Foundation
import WebKit

// Singleton для хранения данных авторизации
final class Session {
    
    // MARK: - Public Properties
    
    static let instance = Session()
    
    var token = ""
    var userid = ""
    var photoUserId: String? = nil
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    // Выйти из VK
    func logoutVK() {
        // Создадть объект хранилища данных сайта
        let dataStore = WKWebsiteDataStore.default()
        // Извлечь данные всех типов и удалить соответствующие фильтру vk
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                for: records.filter { $0.displayName.contains("vk")},
                completionHandler: { }
            )
        }
    }
    
}
