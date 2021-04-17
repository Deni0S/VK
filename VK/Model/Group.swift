import Foundation
import SwiftyJSON
import RealmSwift

final class Group: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var PhotoGroup: String = ""
    
    // MARK: - Initializers
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.Name = json["name"].stringValue
        self.PhotoGroup = json["photo_200"].stringValue
    }
    
    override static func primaryKey() -> String? { "id" }
    
    // Сохранить группы из поиска в Firestore
    func toFirestore() -> [String: Any] {
        [
            String("id") : id,
            String("Name") : Name,
            String("PhotoGroup") : PhotoGroup
        ]
    }
    
}
