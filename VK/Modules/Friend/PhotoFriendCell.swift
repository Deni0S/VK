import UIKit

final class PhotoFriendCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var likeLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var likeCount: Int = 0
    private var timeDuration = 0.5
    
    // MARK: - Public Methods
    
    /// Заполнить ячейку полученными данными и действиями
    public func fillCell(_ photo: Photo, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        // Установить картинку из кеша
        photoImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: photo.url)
        likeLabel?.text = "\(likeCount)"
        likeButton.addTarget(self, action: #selector(likeOnTap), for: .touchDown)
    }
    
}

// MARK: - Private Methods

private extension PhotoFriendCell {
    
    @objc func likeOnTap() {
        if likeCount == 0 {
            likeCount = 1
            UIView.transition(with: likeLabel,
                              duration: timeDuration,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeLabel.text = "1"
                                self.likeLabel.textColor = .rgbaCache(255.0, 0.0, 0.0, 1.0)
            })
            UIView.transition(with: likeButton,
                              duration: timeDuration,
                              options: .transitionCurlDown,
                              animations: {
                                self.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"),
                                                         for: .normal)
            })
        } else {
            likeCount = 0
            UIView.transition(with: likeLabel,
                              duration: timeDuration,
                              options: .transitionFlipFromRight,
                              animations: {
                                self.likeLabel.text = "0"
                                self.likeLabel.textColor = .label
            })
            UIView.transition(with: likeButton,
                              duration: timeDuration,
                              options: .transitionCurlUp,
                              animations: {
                                self.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            })
        }
    }
    
}
