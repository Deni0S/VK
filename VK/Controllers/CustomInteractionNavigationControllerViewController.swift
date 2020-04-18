//
//  CustomInteractionNavigationControllerViewController.swift
//  VK
//
//  Created by Денис Баринов on 15.4.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

// MARK: - Интерактивная анимация
class CustomInteractionNavigationControllerViewController: UINavigationController, UINavigationControllerDelegate {
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return TransitionAnimation(isPresented: true, typeController: "InteractionNavigation")
        } else if operation == .pop {
//            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
                return TransitionAnimation(isPresented: false, typeController: "InteractionNavigation")
//            }
        }
        return nil
    }
}
