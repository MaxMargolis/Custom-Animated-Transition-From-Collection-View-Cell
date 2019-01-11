//
//  CollectionViewController.swift
//  CustomTransitionFromCollectionViewCell
//
//  Created by Max Margolis on 1/10/19.
//  Copyright © 2019 Max Margolis. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
	
	private let reuseIdentifier = "MyCell"
	private let sectionInsets = UIEdgeInsets(top: 20.0,
											 left: 10.0,
											 bottom: 20.0,
											 right: 10.0)
	private let itemsPerRow: CGFloat = 2;
	private var selectedCellFrame: CGRect?

	
	private let dataArray = ["Army Of Shadows", "Battle Of Algiers", "The Big Sleep", "The Killing Of A Chinese Bookie", "Klute", "The Long Goodbye", "The Long Good Friday", "Mean Streets", "Vertigo", "Z"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
		
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
		
        // Configure the cell
		cell.cellLabel.text = dataArray[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
		selectedCellFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
		
		let displayVC = DisplayViewController()
		displayVC.view.frame = view.frame //it's important to set the presented view controller to some well defined size
		displayVC.displayImageView.image = UIImage(named: dataArray[indexPath.row] + ".jpg")
		displayVC.transitioningDelegate = self
		
		self.present(displayVC, animated: true, completion: nil)
	}
}

// MARK: - Collection View Flow Layout Delegate
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
}

//MARK: - View Controller Transitioning Delegate
extension CollectionViewController : UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController,
							 presenting: UIViewController,
							 source: UIViewController)
		-> UIViewControllerAnimatedTransitioning? {
			guard let startFrame = selectedCellFrame else {
				return nil
			}
			return PresentFromCellAnimator(cellFrame: startFrame)
	}
	
	func animationController(forDismissed dismissed: UIViewController)
		-> UIViewControllerAnimatedTransitioning? {
			guard let _ = dismissed as? DisplayViewController,
			let endFrame = selectedCellFrame else {
				return nil
			}
			return DismissToCellAnimator(cellFrame: endFrame)
	}
}

