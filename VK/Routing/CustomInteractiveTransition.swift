import UIKit

final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action:  #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch  recognizer.state {
        case .began:
            // Cтартуем pop анимацию, пользователь начал тянуть
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            // Пользователь продолжает тянуть
            // Рассчитать длину перемещения пальца
            let trenslation = recognizer.translation(in: recognizer.view)
            // Рассчитать процент перемещения пальца относительно ширины экрана
            let relativeTranslation = trenslation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            self.shouldFinish = progress > 0.33
            self.update(progress)
        case .ended:
            // Завершаем анимацию в зависимости от пройденного прогресса
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default:
            return
        }
    }

}
