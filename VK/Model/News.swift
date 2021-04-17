import Foundation
import SwiftyJSON
import RealmSwift

final class News: Object {
    
    @objc dynamic var PostId: Int = 0
    @objc dynamic var SourceId: Int = 0
    @objc dynamic var TypeNews: String = ""
    @objc dynamic var Avatar: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var Date: Double = 0
    @objc dynamic var Photo: String = ""
    @objc dynamic var PhotoWidth: Int = 0
    @objc dynamic var PhotoHeight: Int = 0
    @objc dynamic var TextNews: String = " "
    @objc dynamic var Likes: Int = 0
    @objc dynamic var Comments: Int = 0
    @objc dynamic var Reposts: Int = 0
    @objc dynamic var Views: Int = 0
    
    // MARK: - Initializers
    
    convenience init(json: JSON) {
        self.init()
        
        self.PostId = json["post_id"].intValue
        self.SourceId = json["source_id"].intValue
        self.TypeNews = json["type"].stringValue
        let realm = try! Realm()
        if SourceId > 0 {
            if let newsProfiles = realm.object(ofType: NewsProfiles.self, forPrimaryKey: SourceId) {
                self.Avatar = newsProfiles.Avatar
                self.Name = newsProfiles.Name
            }
        } else {
            if let newsGroups = realm.object(ofType: NewsGroups.self, forPrimaryKey: -SourceId) {
                self.Avatar = newsGroups.Avatar
                self.Name = newsGroups.Name
            }
        }
        self.Date = json["date"].doubleValue
        self.Photo = json["attachments"][0]["photo"]["sizes"][3]["url"].stringValue
        self.PhotoWidth = json["attachments"][0]["photo"]["sizes"][3]["width"].intValue
        self.PhotoHeight = json["attachments"][0]["photo"]["sizes"][3]["height"].intValue
        self.TextNews = json["text"].stringValue
        self.Likes = json["likes"]["count"].intValue
        self.Comments = json["comments"]["count"].intValue
        self.Reposts = json["reposts"]["count"].intValue
        self.Views = json["views"]["count"].intValue
    }
    
    override static func primaryKey() -> String? { "PostId" }
    
}
