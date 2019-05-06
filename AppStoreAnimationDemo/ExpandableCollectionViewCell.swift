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

			let distance = panGesture.translation(in: self).y
			
			switch panGesture.state {

			case .changed:

				if let height = collectionView?.bounds.height {
					
					if distance > height * 0.1 {
						revertCell()
					} else {
						dragCell(panDistance: distance, collectionViewHeight: height)
					}
				}
				
			case .ended:
				
				if let height = collectionView?.bounds.height {

					if distance < height * 0.1 {
						
						snapBackCell()
					}
				}
				
			default:
				break
			}
		}
	}
	
	private func dragCell(panDistance distance: CGFloat, collectionViewHeight height: CGFloat) {
		
		let percentageOfHeight = distance / height
		
		let dragWidth = openedBounds.width - (openedBounds.width * percentageOfHeight)
		
		let dragHeight = openedBounds
			.height - (openedBounds.height * percentageOfHeight)

		let dragOriginX: CGFloat
		let dragOriginY: CGFloat
		
		// take into account if if the original center is greater than or less than the current x/y origin
		if originalCenter.x < openedCenter.x {
			
			let difference = openedCenter.x - originalCenter.x
			dragOriginX = openedCenter.x - (difference * percentageOfHeight)
		} else {
			
			let difference = originalCenter.x - openedCenter.x
			dragOriginX = openedCenter.x + (difference * percentageOfHeight)
		}
		
		if originalCenter.y < openedCenter.y {
			
			let difference = openedCenter.y - originalCenter.y
			
			dragOriginY = openedCenter.y - (difference * percentageOfHeight)
		} else {
			
			let difference = originalCenter.y - openedCenter.y
			dragOriginY = openedCenter.y + (difference * percentageOfHeight)
		}

		self.bounds = CGRect(x: dragOriginX, y: dragOriginY, width: dragWidth, height: dragHeight)
		
		self.layoutIfNeeded()
	}
	
	private func snapBackCell() {
	
		print("snapped back")
		
		isOpen = true
		
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
			
			self.bounds = self.openedBounds
			self.center = self.openedCenter
			
			self.layoutIfNeeded()
		})
	
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

