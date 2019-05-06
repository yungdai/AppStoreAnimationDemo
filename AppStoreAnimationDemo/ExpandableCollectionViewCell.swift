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
	
	var openedBounds: CGRect = CGRect.zero
	var openedCenter: CGPoint = CGPoint.zero
	
	var springDamping: CGFloat = 0.0
	var springVelocity: CGFloat = 0.0
	
	var previousY: CGFloat = 0.0

	weak var collectionView: UICollectionView?
	
	var panGesture = UIPanGestureRecognizer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupGesture()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setupGesture()
	}
	
	private func setupGesture() {


		self.addGestureRecognizer(panGesture)
		panGesture.addTarget(self, action: #selector(cellGestured))
	}
	
	@objc
	private func cellGestured() {
		
		if isOpen {

			switch panGesture.state {

			case .began:
				print("began")

			case .changed:

				let distance = panGesture.translation(in: self).y

				if let height = collectionView?.bounds.height {
					
					if distance > height * 0.1 {
						
						revertCell()
					}

					self.layoutIfNeeded()
				}
	
				self.layoutIfNeeded()
				
			default:
				break
			}
		}
	}
	
	private func revertCell() {
		
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
	
	@IBAction func closeButtonPressed(_ sender: Any) {
		
		revertCell()
	}
}

