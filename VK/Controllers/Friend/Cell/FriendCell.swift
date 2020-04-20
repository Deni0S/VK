//
//  FriendCell.swift,
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var avatarAnimationButton: UIButton!
    
    // Заполнить ячейку полученными данными
    func fillCell(_ friend: User, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        friendName.text = "\(friend.FirstName) \(friend.LastName)"
        // Установить картинку из кеша
        friendAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: friend.PhotoFriend)
    }
    
    // Установить действия в ячейку
    func setupAction() {
        avatarAnimationButton.addTarget(self, action: #selector(avatarAnimationButtonOnTap), for: .touchDown)
    }
    
    @objc func avatarAnimationButtonOnTap() {
        self.friendAvatar.frame.size = CGSize(width: 30, height: 30)
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
                        self.friendAvatar.frame.size = CGSize(width: 70, height: 70)
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
