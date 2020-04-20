//
//  PhotoFriendCell.swift
//  VK
//
//  Created by Денис Баринов on 28.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class PhotoFriendCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    var likeCount: Int = 0
    var timeDuration = 0.5
    
    // Заполнить ячейку полученными данными и действиями
    func fillCell(_ photo: Photo, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        // Установить картинку из кеша
        photoImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: photo.url)
        likeLabel?.text = "\(likeCount)"
        likeButton.addTarget(self, action: #selector(likeOnTap), for: .touchDown)
    }
    
    @objc private func likeOnTap() {
        if likeCount == 0 {
            likeCount = 1
            UIView.transition(with: likeLabel,
                              duration: timeDuration,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.likeLabel.text = "1"
                                self.likeLabel.textColor = .red
            })
            UIView.transition(with: likeButton,
                              duration: timeDuration,
                              options: .transitionCurlDown,
                              animations: {
                                self.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
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
