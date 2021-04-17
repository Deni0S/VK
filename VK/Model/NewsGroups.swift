import Foundation
import SwiftyJSON
import RealmSwift

final class NewsGroups: Object {
    
    @objc dynamic var Id: Int = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Avatar: String = ""
    
    // MARK: - Initializers
    
    convenience init(json: JSON) {
        self.init()
        
        self.Id = json["id"].intValue
        self.Name = json["name"].stringValue
        self.Avatar = json["photo_100"].stringValue
    }
    
    override static func primaryKey() -> String? { "Id" }
    
}
