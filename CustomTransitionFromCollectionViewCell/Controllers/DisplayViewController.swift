//
//  DisplayViewController.swift
//  CustomTransitionFromCollectionViewCell
//
//  Created by Max Margolis on 1/11/19.
//  Copyright © 2019 Max Margolis. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {

	
	@IBOutlet weak var displayImageView: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

    }

	@IBAction func donePressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
}
