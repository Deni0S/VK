//
//  FriendCell.swift,
//  VK
//
//  Created by Денис Баринов on 20.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var friendAvatar: UIImageView! {
        didSet {
            // Отключить автоматическое создание constraints
            friendAvatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var friendName: UILabel! {
        didSet {
            // Отключить автоматическое создание constraints
            friendName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var avatarAnimationButton: UIButton!
    
    // Переопределить метод рассчета позиций элементов
    override func layoutSubviews() {
        super.layoutSubviews()
        manualLayout()
        friendNamePhotoFrame()
    }
    
    // MARK: - Сверстать вручную
    func manualLayout() {
        let photoImageSize: CGFloat = 390
        friendAvatar.frame = CGRect(origin: CGPoint(x: bounds.midX-photoImageSize/2, y: 10), size: CGSize(width: bounds.maxX, height: photoImageSize))
    }
    
    // MARK: - Рассчитать размер текста в UILabel
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // Максимальная ширина текста
        let maxWidth = bounds.width - 20
        // Размеры блока с максимальной шириной и максимально возможной высотой
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // Шрифт и прямоугольник под текст
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        // Размер блока с округлением до большего из Double
        let size = CGSize(width: ceil(Double(rect.size.width)), height: ceil(Double(rect.size.height)))
        return size
    }
    
    // MARK: - Сверстать friendName
    func friendNamePhotoFrame() {
        // Размер текста
        let friendNamePhotoSize = getLabelSize(text: friendName.text!, font: friendName.font)
        // Точка левого верхнего угла надписи
        let friendNamePhotoOrigin = CGPoint(x: (bounds.width - friendNamePhotoSize.width)/2, y: bounds.height - friendNamePhotoSize.height)
        // Получить фрейм и установить namePhoto
        friendName.frame = CGRect(origin: friendNamePhotoOrigin, size: friendNamePhotoSize)
    }
    
    // Заполнить ячейку полученными данными
    func fillCell(_ friend: User, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        friendName.text = "\(friend.FirstName) \(friend.LastName)"
        friendNamePhotoFrame()
        // Установить картинку из кеша
        friendAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: friend.PhotoFriend)
        manualLayout()
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
