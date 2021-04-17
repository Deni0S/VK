import UIKit
import Kingfisher

final class FullPhotoViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var photoImageView: UIImageView?
    
    // MARK: - Public Properties
    
    public var photos: [Photo] = []
    public var indexPath = 0
    
    // MARK: - Private Properties
    
    private var interactivAnimator: UIViewPropertyAnimator!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(onPan(_ :)))
        self.view.addGestureRecognizer(recognizer)
        if let PhotoImage = URL(string: "\(self.photos[self.indexPath].url)") {
            self.photoImageView?.kf.setImage(with: PhotoImage)
        }
    }
    
}

// MARK: - Private Methods

private extension FullPhotoViewController {

    @objc func onPan (_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Разделить жесты смахивания на правый и левый
            let isLeftSwipe = recognizer.velocity(in: view).x > 0
            // Менять индексы в зависимости от направления смахивания
            if isLeftSwipe {
                indexPath -= 1
                if indexPath <= 0 {
                    indexPath = photos.count - 1
                }
            } else {
                indexPath += 1
                if indexPath >= photos.count - 1 {
                    indexPath = 0
                }
            }
            // Создать новый аниматор
            interactivAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn, animations: {
                self.photoImageView?.bounds.size.width = 500
                self.photoImageView?.bounds.size.height = 500
                UIView.transition(with: self.photoImageView!,
                                  duration: 1,
                                  options: isLeftSwipe ? .transitionFlipFromLeft : .transitionFlipFromRight,
                                  animations: {
                                    if let PhotoImage = URL(string: "\(self.photos[self.indexPath].url)") {
                                        self.photoImageView?.kf.setImage(with: PhotoImage)
                                    }
                }) 
            })
            // Поставить анимацию на паузу
            interactivAnimator?.pauseAnimation()
        case .changed:
            // Считать перемещение распознователя внутри View нахождения
            let translation = recognizer.translation(in: self.view)
            // Установить значение перемещения деленное на 100
            interactivAnimator.fractionComplete = abs(translation.x) / 100
        case .ended:
            // Разделить жесты смахивания на правой и левой половине экрана
            let isLeftScreen = recognizer.location(in: view).x < UIScreen.main.bounds.width / 2
            // Продолжить анимацию с текущего места или отменить в случае обратного свайпа
            let isCancelSwipe = isLeftScreen ? recognizer.translation(in: view).x > 10 : recognizer.translation(in: view).x < -10
            print(recognizer.translation(in: view).x)
            if isCancelSwipe {
                interactivAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                interactivAnimator.stopAnimation(true)
                interactivAnimator.finishAnimation(at: isLeftScreen ? .end : .start)
                self.photoImageView?.bounds.size.width = UIScreen.main.bounds.width
                self.photoImageView?.bounds.size.height = UIScreen.main.bounds.height
            }
        default:
            return
        }
    }

}
