import Foundation
import SwiftyJSON
import RealmSwift

final class Photo: Object {
    
    @objc dynamic var url: String = ""
    @objc dynamic var text: String = ""
    
    // MARK: - Initializers
    
    convenience init(json: JSON) {
        self.init()
        self.url = json["sizes"][3]["url"].stringValue
        self.text = json["text"].stringValue
    }
    
    override static func primaryKey() -> String? { "url" }

}
