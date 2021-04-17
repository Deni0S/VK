import Foundation

protocol VKServiceInterface {
    func getPhoto(id: String?, complition: ((Error?) -> Void)?)
    func getFriend(complition: ((Error?) -> Void)?)
    func getGroup(complition: ((Error?) -> Void)?)
    func getGroupSearch(search: String, complition: (([Group]?, (Error?)) -> Void)?)
    func getNews(dateLastNews: Double?, isRefresh: Bool, complition: ((Error?) -> Void)?)
}

// Проксирует открытие VKService
final class VKServiceProxy: VKServiceInterface {
    
    // MARK: - Private Properties
    
    private let vkService = VKService()
    
    // MARK: - Public Methods
    
    func getAll(search: String = "") {
        getPhoto()
        getFriend()
        getGroup()
        getGroupSearch(search: search)
        getNews()
    }
    
    func getPhoto(id: String? = nil, complition: ((Error?) -> Void)? = nil) {
        vkService.getPhoto(id: id,
                           complition: complition)
        print("Called func getPhoto")
    }
    
    func getFriend(complition: ((Error?) -> Void)? = nil) {
        vkService.getFriend(complition: complition)
        print("Called func getFriend")
    }
    
    func getGroup(complition: ((Error?) -> Void)? = nil) {
        vkService.getGroup(complition: complition)
        print("Called func getGroup")
    }
    
    func getGroupSearch(search: String, complition: (([Group]?, (Error?)) -> Void)? = nil) {
        vkService.getGroupSearch(search: search,
                                 complition: complition)
        print("Called func getGroupSearch")
    }
    
    func getNews(dateLastNews: Double? = nil, isRefresh: Bool = false, complition: ((Error?) -> Void)? = nil) {
        vkService.getNews(dateLastNews: dateLastNews,
                          isRefresh: isRefresh,
                          complition: complition)
        print("Called func getNews")
    }
    
}
