import UIKit

final class TransitionAnimation: NSObject {
    
    // MARK: - Public Properties
    
    enum TypeController {
        case login
        case interactionNavigation
    }
    
    // MARK: - Private Properties
    
    private let isPresented: Bool
    private let typeController: TypeController
    
    // MARK: - Lifecycle
    
    init(isPresented: Bool, typeController: TypeController) {
        self.isPresented = isPresented
        self.typeController = typeController
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension TransitionAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 1 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ?
            presented(using: transitionContext) :
            dismissed(using: transitionContext)
    }

}

// MARK: - Private Methods

private extension TransitionAnimation {
    
    func presented (using transitionContext: UIViewControllerContextTransitioning) {
        switch typeController {
            case .login:
                let containerView = transitionContext.containerView
                guard let toView = transitionContext.view(forKey: .to),
                      let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                toView.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2).concatenating(CGAffineTransform(translationX: (UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
                containerView.addSubview(toView)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.transform = CGAffineTransform(rotationAngle: .pi / 2).concatenating(CGAffineTransform(translationX: -(UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
                    toView.transform = CGAffineTransform(translationX: 0,
                                                         y: 0)
                }) { (finish) in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(finish)
                }
                
            case .interactionNavigation:
                let containerView = transitionContext.containerView
                guard let toView = transitionContext.view(forKey: .to),
                      let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                toView.frame.origin.x = UIScreen.main.bounds.width
                containerView.addSubview(toView)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.frame.origin.x = -UIScreen.main.bounds.width
                    toView.frame.origin.x = 0
                }) { (finish) in
                    transitionContext.completeTransition(finish)
                }
        }
    }
    
    func dismissed (using transitionContext: UIViewControllerContextTransitioning) {
        switch typeController {
            case .login:
                let containerView = transitionContext.containerView
                guard let toView = transitionContext.view(forKey: .to),
                      let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                toView.transform = CGAffineTransform(rotationAngle: .pi / 2).concatenating(CGAffineTransform(translationX: -(UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
                containerView.addSubview(toView)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2).concatenating(CGAffineTransform(translationX: (UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
                    toView.transform = CGAffineTransform(translationX: 0, y: 0)
                }) { (finish) in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(finish)
                }
                
            case .interactionNavigation:
                let containerView = transitionContext.containerView
                guard let toView = transitionContext.view(forKey: .to),
                      let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                toView.frame.origin.x = -UIScreen.main.bounds.width
                containerView.addSubview(toView)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    toView.frame.origin.x = 0
                    fromView.frame.origin.x = UIScreen.main.bounds.width
                }) { (finish) in
                    transitionContext.completeTransition(finish)
                }
        }
    }
    
}
