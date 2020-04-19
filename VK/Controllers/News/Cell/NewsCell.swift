//
//  NewsCell.swift
//  VK
//
//  Created by Денис Баринов on 9.2.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postDataLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }

    // MARK: - Заполнить ячейку
    func setupWithNews(_ news: News, _ indexPath: IndexPath) {
        nameLabel.text = "\(news.Name)"
        newsTextView.text = "\(news.TextNews)"
        likesLabel.text = "\(news.Likes)"
        commentsLabel.text = "\(news.Comments)"
        repostsLabel.text = "\(news.Reposts)"
        viewsLabel.text = "\(news.Views)"
        if let PhotoImage = URL(string: "\(news.Avatar)") {
            avatarImageView.kf.setImage(with: PhotoImage)
        }
        if let PhotoImage = URL(string: "\(news.Photo)") {
            newsImageView.kf.setImage(with: PhotoImage)
        }
        let date = Date(timeIntervalSince1970: news.Date)
        postDataLabel.text = dateFormatter.string(from: date)
    }
}
