//
//  CustomSegue.swift
//  CustomSegueDemo
//
//  Created by Timothy Moose on 6/13/18.
//  Copyright © 2018 it.swiftkick. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {

    var height: CGFloat? = nil
    private var selfRetainer: CustomSegue? = nil

    override func perform() {
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        destination.transitioningDelegate = self
        source.present(destination, animated: true, completion: nil)
    }
}

extension CustomSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        return self
    }
}

extension CustomSegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return selfRetainer == nil ? 0.2 : 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch selfRetainer {
        case .some: animatePresentation(using: transitionContext)
        case .none: animateDismissal(using: transitionContext)
        }
    }

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        // Configure the layout
        do {
            toView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(toView)
            container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
            container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -20).isActive = true
            container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 20).isActive = true
            if let height = height {
                toView.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
        // Apply some styling
        do {
            toView.layer.masksToBounds = true
            toView.layer.cornerRadius = 20
        }
        // Perform the animation
        do {
            container.layoutIfNeeded()
            let originalOriginY = toView.frame.origin.y
            toView.frame.origin.y += container.frame.height - toView.frame.minY
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                toView.frame.origin.y = originalOriginY
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        }
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        UIView.animate(withDuration: 0.2, animations: {
            fromView.frame.origin.y += container.frame.height - fromView.frame.minY
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

