//
//  GroupSearchCell.swift
//  VK
//
//  Created by Денис Баринов on 21.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class GroupSearchCell: UITableViewCell {
    @IBOutlet weak var groupSearchAvatar: UIImageView!
    @IBOutlet weak var groupSearchName: UILabel!
    
    // Заполнить ячейку полученными данными и действиями
    func fillCell(_ group: Group) {
        groupSearchName.text = "\(group.Name)"
        if let GroupImage = URL(string: "\(group.PhotoGroup)") {
            groupSearchAvatar.kf.setImage(with: GroupImage)
        }
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
