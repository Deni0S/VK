//
//  TransitionAnimation.swift
//  VK
//
//  Created by Денис Баринов on 14.4.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresented: Bool
    let typeController: String
    
    init(isPresented: Bool, typeController: String) {
        self.isPresented = isPresented
        self.typeController = typeController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            presented(using: transitionContext)
        } else {
            dismissed(using: transitionContext)
        }
    }
    
    func presented (using transitionContext: UIViewControllerContextTransitioning) {
        switch typeController {
        case "Login":
            let containerView = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            toView.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2).concatenating(CGAffineTransform(translationX: (UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
            containerView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.transform = CGAffineTransform(rotationAngle: .pi / 2).concatenating(CGAffineTransform(translationX: -(UIScreen.main.bounds.height + UIScreen.main.bounds.width)/2, y: -UIScreen.main.bounds.width/2))
                toView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (finish) in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finish)
            }
        case "InteractionNavigation":
            let containerView = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from) else {
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
            return
        default: transitionContext.completeTransition(false)
        }
    }
    
    func dismissed (using transitionContext: UIViewControllerContextTransitioning) {
        switch typeController {
        case "Login":
            let containerView = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from) else {
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
        case "InteractionNavigation":
            let containerView = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: .to), let fromView = transitionContext.view(forKey: .from) else {
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
            return
        default: transitionContext.completeTransition(false)
        }
    }
}
