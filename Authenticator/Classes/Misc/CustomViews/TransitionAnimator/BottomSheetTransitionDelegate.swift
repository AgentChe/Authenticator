//
//  BottomSheetTransitionDelegate.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 29.04.2024.
//

import UIKit

class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitonAnimator(duration: 0.3, type: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertTransitonAnimator(duration: 0.3, type: .dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        BottomSheetPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
