//
//  BottomCardSegue.swift
//  CustomSegueDemo
//
//  Created by Timothy Moose on 6/13/18.
//  Copyright © 2018 it.swiftkick. All rights reserved.
//

import UIKit

class BottomCardSegue: UIStoryboardSegue {

    // Need to retain self until dismissal because UIKit won't.
    private var selfRetainer: BottomCardSegue? = nil

    override func perform() {
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        destination.transitioningDelegate = self
        source.present(destination, animated: true, completion: nil)
    }
}

extension BottomCardSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Presenter()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        return Dismisser()
    }

    private class Presenter: NSObject, UIViewControllerAnimatedTransitioning {

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let toView = transitionContext.view(forKey: .to)!
            let toViewController = transitionContext.viewController(forKey: .to)!
            // Configure the layout
            do {
                toView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(toView)
                // Specify a minimum 20pt bottom margin
                let bottom = max(20 - toView.safeAreaInsets.bottom, 0)
                container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom).isActive = true
                container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -20).isActive = true
                container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 20).isActive = true
                // Respect `toViewController.preferredContentSize.height` if non-zero.
                if toViewController.preferredContentSize.height > 0 {
                    toView.heightAnchor.constraint(equalToConstant: toViewController.preferredContentSize.height).isActive = true
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
    }

    private class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.2
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: 0.2, animations: {
                fromView.frame.origin.y += container.frame.height - fromView.frame.minY
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        }
    }
}



