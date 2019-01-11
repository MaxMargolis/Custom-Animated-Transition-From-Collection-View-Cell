//
//  DismissToCellAnimator.swift
//  CustomTransitionFromCollectionViewCell
//
//  Created by Max Margolis on 1/11/19.
//  Copyright © 2019 Max Margolis. All rights reserved.
//

import UIKit

class DismissToCellAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	private let cellFrame: CGRect
	
	init(cellFrame: CGRect) {
		self.cellFrame = cellFrame
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.5
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		//Grab some useful references and a snapshot of the ending view
		guard let fromVC = transitionContext.viewController(forKey: .from),
			let toVC = transitionContext.viewController(forKey: .to),
			let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
			else {
				return
		}
		let endFrame = cellFrame
		
		/*Here's the plan:
		1. UIKit provides a container view for helping to manage the transition so we start by hiding the starting view and stack in this container an invisible version of the ending cell and the snapshot of the starting view
		2. We start animating shrinking the snapshot to the size of the ending cell. This lasts 92% of the transition.
		3. We wait until 20% of the transition is done then fade out the snapshot
		4. Then at the end, we un-hide the starting view in case the transition failed/was cancelled
		*/
		
		snapshot.frame = transitionContext.initialFrame(for: fromVC)
		
		fromVC.view.isHidden = true
		transitionContext.containerView.insertSubview(toVC.view, at: 0)
		transitionContext.containerView.addSubview(snapshot)
		
		UIView.animateKeyframes(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .calculationModeCubic,
			animations: {
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.92, animations: {
					snapshot.frame = endFrame
				})
				UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
					snapshot.alpha = 0.0
				})
		}, completion: { _ in
			fromVC.view.isHidden = false
			snapshot.removeFromSuperview()
			if transitionContext.transitionWasCancelled {
				toVC.view.removeFromSuperview()
			}
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
		
	}
	

}
