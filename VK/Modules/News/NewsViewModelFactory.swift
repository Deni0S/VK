import Foundation

// Simple Factory
final class NewsViewModelFactory {
    
    func constructViewModel(from news: [News]) -> [NewsViewModel] {
        news.compactMap(self.viewModel)
    }

}

// MARK: - Private Methods

private extension NewsViewModelFactory {
    
    private func viewModel(from news: News) -> NewsViewModel {
        NewsViewModel(Avatar: news.Avatar,
                      Name: news.Name,
                      Date: news.Date,
                      Photo: news.Photo,
                      TextNews: news.TextNews,
                      Likes: String(news.Likes),
                      Comments: String(news.Comments),
                      Reposts: String(news.Reposts),
                      Views: String(news.Views))
    }
    
}
