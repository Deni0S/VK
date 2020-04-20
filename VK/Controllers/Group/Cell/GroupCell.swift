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
    @IBOutlet weak var groupAvatar: UIImageView! {
        didSet {
            // Отключить автоматическое создание constraints
            groupAvatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var groupName: UILabel! {
        didSet {
            // Отключить автоматическое создание constraints
            groupName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var avatarAnimationButton: UIButton!
    
    // Переопределить метод рассчета позиций элементов
    override func layoutSubviews() {
        super.layoutSubviews()
        manualLayout()
        groupAvatarFrame()
    }
    
    // MARK: - Сверстать вручную
    func manualLayout() {
        let photoImageSize: CGFloat = 390
        groupAvatar.frame = CGRect(origin: CGPoint(x: bounds.midX-photoImageSize/2, y: 10), size: CGSize(width: bounds.maxX, height: photoImageSize))
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
    
    // MARK: - Сверстать nameGroup
    func groupAvatarFrame() {
        // Размер текста
        let nameGroupPhotoSize = getLabelSize(text: groupName.text!, font: groupName.font)
        // Точка левого верхнего угла надписи
        let nameGroupPhotoOrigin = CGPoint(x: (bounds.width - nameGroupPhotoSize.width)/2, y: bounds.height - nameGroupPhotoSize.height)
        // Получить фрейм и установить namePhoto
        groupName.frame = CGRect(origin: nameGroupPhotoOrigin, size: nameGroupPhotoSize)
    }
    
    // Заполнить ячейку полученными данными и действиями
    func fillCell(_ group: Group, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        groupName.text = "\(group.Name)"
        groupAvatarFrame()
        // Установить картинку из кеша
        groupAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: group.PhotoGroup)
        avatarAnimationButton.addTarget(self, action: #selector(avatarAnimationButtonOnTap), for: .touchDown)
        manualLayout()
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
