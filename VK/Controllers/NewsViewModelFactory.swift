//
//  NewsViewModelFactory.swift
//  VK
//
//  Created by Денис Баринов on 21.5.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import Foundation

// Simple Factory
final class NewsViewModelFactory {
    func constructViewModel(from news: [News]) -> [NewsViewModel] {
        return news.compactMap(self.viewModel)
    }
    
    private func viewModel(from news: News) -> NewsViewModel {
        let nameLabel = news.Name
        let newsTextView = news.TextNews
        let likesLabel = String(news.Likes)
        let commentsLabel = String(news.Comments)
        let repostsLabel = String(news.Reposts)
        let viewsLabel = String(news.Views)
        let postDataLabel = news.Date
        let avatarImageView = news.Avatar
        let newsImageView = news.Photo
        
        return NewsViewModel(Avatar: avatarImageView, Name: nameLabel, Date: postDataLabel, Photo: newsImageView, TextNews: newsTextView, Likes: likesLabel, Comments: commentsLabel, Reposts: repostsLabel, Views: viewsLabel)
    }
}
