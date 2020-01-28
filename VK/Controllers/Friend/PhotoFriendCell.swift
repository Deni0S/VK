//
//  PhotoFriendCell.swift
//  VK
//
//  Created by Денис Баринов on 28.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class PhotoFriendCell: UICollectionViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    var likeCount: Int = 0
    
    func setupCell() {
    likeButton.addTarget(self, action: #selector(likeOnTap), for: .touchDown)
    }
    
    @objc private func likeOnTap() {
        if likeCount == 0 {
            likeCount = 1
            likeLabel.text = "1"
            likeLabel.textColor = .red
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        } else {
            likeCount = 0
            likeLabel.text = "0"
            likeLabel.textColor = .label
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
    }
}
