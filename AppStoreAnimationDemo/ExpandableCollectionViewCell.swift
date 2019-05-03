//
//  ExpandableCollectionViewCell.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-03.
//

import UIKit

class ExpandableCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var headerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var titleFont: UILabel!
	@IBOutlet weak var closeButton: UIButton!
	
	var isOpen = false
	
	var originalBounds: CGRect = CGRect.zero
	var originalCenter: CGPoint = CGPoint.zero
	
	var springDamping: CGFloat = 0.0
	var springVelocity: CGFloat = 0.0

	weak var collectionView: UICollectionView?
	
	@IBAction func closeButtonPressed(_ sender: Any) {
		
		isOpen.toggle()
		
		UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
			
			self.bounds = self.originalBounds
			self.center = self.originalCenter
			
			self.closeButton.isHidden = true
			self.closeButton.alpha = 0

			self.collectionView?.isScrollEnabled = true

			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant / 2
			
			// used to layout the new height constraint of the image
			self.layoutIfNeeded()
		})
	}
}
