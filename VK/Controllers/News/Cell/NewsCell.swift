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

    // MARK: - Заполнить ячейку (deprecated)
    func fillCell(_ news: News, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        nameLabel.text = "\(news.Name)"
        newsTextView.text = "\(news.TextNews)"
        likesLabel.text = "\(news.Likes)"
        commentsLabel.text = "\(news.Comments)"
        repostsLabel.text = "\(news.Reposts)"
        viewsLabel.text = "\(news.Views)"
        // Установить дату из кеша
        postDataLabel.text = dataProcessing.getDateText(forIndexPath: indexPath, andTimestemp: news.Date)
         // Установить картинку из кеша
        avatarImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: news.Avatar)
        newsImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: news.Photo)
    }
    
    // MARK: - Заполнить ячейку используя фабрику
    func fillCellFactory(with viewModel: NewsViewModel, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        nameLabel.text = viewModel.Name
        newsTextView.text = viewModel.TextNews
        likesLabel.text = viewModel.Likes
        commentsLabel.text = viewModel.Comments
        repostsLabel.text = viewModel.Reposts
        viewsLabel.text = viewModel.Views
        // Установить дату из кеша
        postDataLabel.text = dataProcessing.getDateText(forIndexPath: indexPath, andTimestemp: viewModel.Date)
         // Установить картинку из кеша
        avatarImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: viewModel.Avatar)
        newsImageView.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: viewModel.Photo)
    }
}
