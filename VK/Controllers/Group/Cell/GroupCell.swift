//
//  GroupCell.swift
//  VK
//
//  Created by Денис Баринов on 21.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import Kingfisher

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupAvatar: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var avatarAnimationButton: UIButton!
    
    // Заполнить ячейку полученными данными и действиями
    func fillCell(_ group: Group, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        groupName.text = "\(group.Name)"
        // Установить картинку из кеша
        groupAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: group.PhotoGroup)
        avatarAnimationButton.addTarget(self, action: #selector(avatarAnimationButtonOnTap), for: .touchDown)
    }
    
    @objc func avatarAnimationButtonOnTap() {
        self.groupAvatar.frame.size = CGSize(width: 30, height: 30)
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
                        self.groupAvatar.frame.size = CGSize(width: 70, height: 70)
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
