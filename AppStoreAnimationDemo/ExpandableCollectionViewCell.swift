//
//  ExpandableCollectionViewCell.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-03.
//

import UIKit
import UIExpandableCVCellKit

class ExpandableCollectionViewCell: UICollectionViewCell, ExpandedCellProtocol {

	@IBOutlet var headerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var containterView: UIView!
	@IBOutlet weak var titleFont: UILabel!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var bodyText: UILabel!
	@IBOutlet weak var findOutMoreLabel: UILabel!

	internal var originalBounds: CGRect = CGRect.zero
	internal var originalCenter: CGPoint = CGPoint.zero
	
	internal var openedBounds: CGRect = CGRect.zero
	internal var openedCenter: CGPoint = CGPoint.zero
	
	internal var springDamping: CGFloat = 0.0
	internal var springVelocity: CGFloat = 0.0
	
	internal var animationDuration: TimeInterval = 0.0
	
	// threshold expressed in percentage of when the snapping should occure
	internal var dragThreshold: CGFloat = 0.15
	internal var panGesture = UIPanGestureRecognizer()
	
	internal var expandedCellCollectionProtocol: ExpandedCellCollectionProtocol?

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupPanGesture(selector: #selector(cellGestured))
		setupGesture()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		setupGesture()
	}
	
	override func awakeFromNib() {
		
		setup()
	}
	
	private func setup() {

		bodyText.alpha = 0
		closeButton.alpha = 0
		closeButton.isHidden = true
		containterView.layer.cornerRadius = 15
		containterView.layer.shadowColor = UIColor.black.cgColor
		containterView.layer.shadowRadius = 4
		containterView.layer.shadowOpacity = 0.3

		closeButton.layer.backgroundColor = UIColor.lightGray.cgColor
		closeButton.layer.cornerRadius = closeButton.bounds.width / 2

		headerView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		headerView.layer.cornerRadius = 15
	}

	private func setupGesture() {

		self.addGestureRecognizer(panGesture)
		panGesture.addTarget(self, action: #selector(cellGestured))
		panGesture.isEnabled = false
	}

	@objc
	internal func cellGestured() {
		
		cellGesturedLogic()
	}
	
	func openCell() {

		animateCellOpenLogic()
		
		UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {


			self.closeButton.isHidden = false
			self.closeButton.alpha = 1
			
			self.bodyText.alpha = 1
			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant * 2

			self.findOutMoreLabel.animateText(text: "New ways to open cells!", duration: self.animationDuration)

			// use this because we are changing the height constraint for the image
			self.layoutIfNeeded()
		}, completion: nil)
		
	}

	internal func snapBackCell() {

		snapBackLogic()
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {

			self.closeButton.alpha = 1
			self.bodyText.alpha = 1
			self.layoutIfNeeded()
		})
	}
	
	internal func closeCell() {
		
		closeCellLogic()
		
		// Additional logic to close the cell
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {

			
			self.closeButton.isHidden = true
			self.closeButton.alpha = 0
			
			self.bodyText.alpha = 0

			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant / 2

			self.findOutMoreLabel.animateText(text: "Find out more:", duration: self.animationDuration)
			// used to layout the new height constraint of the image
			self.layoutIfNeeded()
		})
	}
	
	@IBAction func closeButtonPressed(_ sender: Any) {
		
		closeCell()
	}
}

