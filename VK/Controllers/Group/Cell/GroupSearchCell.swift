//
//  GroupSearchCell.swift
//  VK
//
//  Created by Денис Баринов on 21.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class GroupSearchCell: UITableViewCell {
    @IBOutlet weak var groupSearchAvatar: UIImageView! {
        didSet {
            // Отключить автоматическое создание constraints
            groupSearchAvatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var groupSearchName: UILabel! {
        didSet {
            // Отключить автоматическое создание constraints
            groupSearchName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // Переопределить метод рассчета позиций элементов
    override func layoutSubviews() {
        super.layoutSubviews()
        manualLayout()
        groupSearchAvatarFrame()
    }
    
    // MARK: - Сверстать вручную
    func manualLayout() {
        let photoImageSize: CGFloat = 390
        groupSearchAvatar.frame = CGRect(origin: CGPoint(x: bounds.midX-photoImageSize/2, y: 10), size: CGSize(width: bounds.maxX, height: photoImageSize))
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
    func groupSearchAvatarFrame() {
        // Размер текста
        let nameGroupPhotoSize = getLabelSize(text: groupSearchName.text!, font: groupSearchName.font)
        // Точка левого верхнего угла надписи
        let nameGroupPhotoOrigin = CGPoint(x: (bounds.width - nameGroupPhotoSize.width)/2, y: bounds.height - nameGroupPhotoSize.height)
        // Получить фрейм и установить namePhoto
        groupSearchName.frame = CGRect(origin: nameGroupPhotoOrigin, size: nameGroupPhotoSize)
    }
    
    // Заполнить ячейку полученными данными и действиями
    func fillCell(_ group: Group, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        groupSearchName.text = "\(group.Name)"
        // Установить картинку из кеша
        groupSearchAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: group.PhotoGroup)
        manualLayout()
        groupSearchAvatarFrame()
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
