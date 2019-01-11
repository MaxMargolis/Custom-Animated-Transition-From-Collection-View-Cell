//
//  TransitionAnimator.swift
//  CustomTransitionFromCollectionViewCell
//
//  Created by Max Margolis on 1/10/19.
//  Copyright © 2019 Max Margolis. All rights reserved.
//

import UIKit

class PresentFromCellAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	private let cellFrame: CGRect
	
	init(cellFrame: CGRect) {
		self.cellFrame = cellFrame
	}
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		
		//Change to a large amount of time here to see what's going on in the animation more clearly
		return 0.5
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		//Grab some useful references and a snapshot of the ending view
		guard let toVC = transitionContext.viewController(forKey: .to),
			let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
			else {
				return
		}
		let endFrame = transitionContext.finalFrame(for: toVC)
		
		/*Here's the plan:
		1. UIKit provides a container view for helping to manage the transition so we start by stacking invisible versions of the ending view and the snapshot of the ending view (but sized to the starting cell) in this container
		2. We animate making the snapshot visible for the first 10% of the transition
		3. We animate sizing the snapshot to fill the end view throughout the transition
		4. At this point the snapshot matches the ending view, so we can remove it and make the actual ending view visible
		*/
		
		snapshot.alpha = 0.0
		snapshot.frame = cellFrame
		
		toVC.view.isHidden = true
		transitionContext.containerView.addSubview(toVC.view)
		transitionContext.containerView.addSubview(snapshot)
		
		UIView.animateKeyframes(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .calculationModeCubic,
			animations: {
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
					snapshot.alpha = 1.0
				})
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
					snapshot.frame = endFrame
				})
		}, completion: { _ in
			toVC.view.isHidden = false
			snapshot.removeFromSuperview()
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
		
	}
	
	

}
