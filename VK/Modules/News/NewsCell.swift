import UIKit

final class NewsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var postDataLabel: UILabel!
    @IBOutlet private var newsImageView: UIImageView!
    @IBOutlet private var newsTextView: UITextView!
    @IBOutlet private var likesLabel: UILabel!
    @IBOutlet private var commentsLabel: UILabel!
    @IBOutlet private var repostsLabel: UILabel!
    @IBOutlet private var viewsLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var indexCell: IndexPath? {
        didSet {
            avatarImageView.image = nil
            newsImageView.image = nil
        }
    }
    
    // MARK: - Public Methods
    
    /// Заполнить ячейку используя фабрику
    public  func fillCellFactory(with viewModel: NewsViewModel, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        nameLabel.text = viewModel.Name
        newsTextView.text = viewModel.TextNews
        likesLabel.text = viewModel.Likes
        commentsLabel.text = viewModel.Comments
        repostsLabel.text = viewModel.Reposts
        viewsLabel.text = viewModel.Views
        // Установить дату из кеша
        postDataLabel.text = dataProcessing.getDateText(forIndexPath: indexPath,
                                                        andTimestemp: viewModel.Date)
         // Установить картинку из кеша
        avatarImageView.image = dataProcessing.photo(atIndexpath: indexPath,
                                                     byUrl: viewModel.Avatar)
        newsImageView.image = dataProcessing.photo(atIndexpath: indexPath,
                                                   byUrl: viewModel.Photo)
    }
    
}
