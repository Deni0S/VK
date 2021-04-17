import Foundation
import SwiftyJSON
import RealmSwift

final class User: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var FirstName: String = ""
    @objc dynamic var LastName: String = ""
    @objc dynamic var PhotoFriend: String = ""
    
    // MARK: - Initializers
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.FirstName = json["first_name"].stringValue
        self.LastName = json["last_name"].stringValue
        self.PhotoFriend = json["photo_200_orig"].stringValue
    }
    
    override static func primaryKey() -> String? { "id" }
    
}
