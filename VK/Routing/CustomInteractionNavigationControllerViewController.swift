import UIKit

// Интерактивная анимация
final class CustomInteractionNavigationControllerViewController: UINavigationController {
   
    // MARK: - Private Properties
    
    private let interactiveTransition = CustomInteractiveTransition()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
}

// MARK: - UINavigationControllerDelegate

extension CustomInteractionNavigationControllerViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return TransitionAnimation(isPresented: true, typeController: .interactionNavigation)
        } else if operation == .pop {
//            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            return TransitionAnimation(isPresented: false, typeController: .interactionNavigation)
//            }
        }
        return nil
    }
    
}
