import UIKit

final class GroupSearchCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var groupSearchAvatar: UIImageView! {
        // Отключить автоматическое создание constraints
        didSet { groupSearchAvatar.translatesAutoresizingMaskIntoConstraints = false }
    }
    @IBOutlet private var groupSearchName: UILabel! {
        // Отключить автоматическое создание constraints
        didSet { groupSearchName.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    // MARK: - Lifecycle
    
    // Переопределить метод рассчета позиций элементов
    override func layoutSubviews() {
        super.layoutSubviews()
        
        manualLayout()
        groupSearchAvatarFrame()
    }
    
    // MARK: - Public Methods
    
    /// Заполнить ячейку полученными данными и действиями
    public func fillCell(_ group: Group, _ indexPath: IndexPath, _ dataProcessing: DataProcessingService) {
        groupSearchName.text = "\(group.Name)"
        // Установить картинку из кеша
        groupSearchAvatar.image = dataProcessing.photo(atIndexpath: indexPath, byUrl: group.PhotoGroup)
        manualLayout()
        groupSearchAvatarFrame()
    }
    
}

// MARK: - Private Methods

private extension GroupSearchCell{
    
    // Сверстать вручную
    func manualLayout() {
        let photoImageSize: CGFloat = 390
        groupSearchAvatar.frame = CGRect(origin: CGPoint(x: bounds.midX-photoImageSize/2,
                                                         y: 10),
                                         size: CGSize(width: bounds.maxX,
                                                      height: photoImageSize))
    }
    
    // Рассчитать размер текста в UILabel
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // Максимальная ширина текста
        let maxWidth = bounds.width - 20
        // Размеры блока с максимальной шириной и максимально возможной высотой
        let textBlock = CGSize(width: maxWidth,
                               height: CGFloat.greatestFiniteMagnitude)
        // Шрифт и прямоугольник под текст
        let rect = text.boundingRect(with: textBlock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        // Размер блока с округлением до большего из Double
        let size = CGSize(width: ceil(Double(rect.size.width)),
                          height: ceil(Double(rect.size.height)))
        return size
    }
    
    // Сверстать nameGroup
    func groupSearchAvatarFrame() {
        // Размер текста
        let nameGroupPhotoSize = getLabelSize(text: groupSearchName.text!,
                                              font: groupSearchName.font)
        // Точка левого верхнего угла надписи
        let nameGroupPhotoOrigin = CGPoint(x: (bounds.width - nameGroupPhotoSize.width)/2,
                                           y: bounds.height - nameGroupPhotoSize.height)
        // Получить фрейм и установить namePhoto
        groupSearchName.frame = CGRect(origin: nameGroupPhotoOrigin,
                                       size: nameGroupPhotoSize)
    }
    
}
