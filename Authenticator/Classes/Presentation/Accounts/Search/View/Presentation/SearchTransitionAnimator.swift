//
//  SearchTransitionAnimator.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 19.05.2024.
//

import UIKit

class SearchTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum AnimationType {
        case present
        case dismiss
    }
    
    let duration: TimeInterval
    let animationType: AnimationType
    let startYPosition: CGFloat
    
    init(duration: TimeInterval, type: AnimationType, yPosition: CGFloat) {
        self.duration = duration
        self.animationType = type
        self.startYPosition = yPosition
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            presentAnimation(using: transitionContext)
        case .dismiss:
            dismissAnimation(using: transitionContext)
        }
    }
}

// MARK: Private
private extension SearchTransitionAnimator {
    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to)else { return }
        let container = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: to)
        
        to.view.frame = finalFrame
        container.addSubview(to.view)
        let searchView = to.view as? SearchAccountView
        searchView?.searchField.becomeFirstResponder()
    }
    
    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }
        let initialFrame = transitionContext.initialFrame(for: from)
                
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.view.frame = initialFrame.offsetBy(dx: 0, dy: self.startYPosition)
        }
                
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animator.startAnimation()
    }
}

class SearchTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var startYPosition: CGFloat = .zero
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SearchTransitionAnimator(duration: 0.3, type: .present, yPosition: startYPosition)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SearchTransitionAnimator(duration: 0.3, type: .dismiss, yPosition: startYPosition)
    }
}
