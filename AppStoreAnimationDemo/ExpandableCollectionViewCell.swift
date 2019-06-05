//
//  ExpandableCollectionViewCell.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-03.
//

import UIKit
import UIExpandableCVCellKit

final class ExpandableCollectionViewCell: UICollectionViewCell, ExpandableCVCellProtocol {
	
	@IBOutlet var headerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var bodyContainerWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var contentContainerView: UIView!
	@IBOutlet weak var titleFont: UILabel!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var bodyText: UILabel!
	@IBOutlet weak var findOutMoreLabel: UILabel!

	internal var expandableCVProtocol: ExpandableCVProtocol?
	internal var viewModel: ExpandableCellViewModel?
	internal var panGesture = UIPanGestureRecognizer()
	
	private let cornerRadius: CGFloat = 15

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
		
		containerView.layer.cornerRadius = 15
		containerView.layer.shadowColor = UIColor.black.cgColor
		containerView.layer.shadowRadius = 4
		containerView.layer.shadowOpacity = 0.3
		containerView.layer.shadowOffset = CGSize(width: 0, height: 0)

		closeButton.layer.backgroundColor = UIColor.lightGray.cgColor
		closeButton.layer.cornerRadius = closeButton.bounds.width / 2

		let margin: CGFloat = 20.0
		
		contentContainerView.layer.cornerRadius = cornerRadius
		
		headerView.layer.cornerRadius = cornerRadius
		headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

		let textContainerWidth = self.containerView.bounds.width - (margin * 2)
		
		bodyContainerWidthConstraint.constant = textContainerWidth
		
		bodyText.setNeedsUpdateConstraints()
		
		contentContainerView.layoutIfNeeded()
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
	
	func openCellHandler() -> (handler: Handler?, completion: Handler?, isAnimated: Bool) {
		let animations = {
			self.closeButton.isHidden = false
			self.closeButton.alpha = 1
			
			self.bodyText.alpha = 1
			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant * 2
			
			self.findOutMoreLabel.animateText(text: "New ways to open cells!", duration: 0.1)
			
			self.headerView.layer.cornerRadius = 0
			self.containerView.layer.cornerRadius = 0
		}

		return (handler: animations, completion: nil, isAnimated: true)
	}


	internal func snapBackCellHandler() -> (handler: Handler?, completion: Handler?, isAnimated: Bool) {
		
		
		let animations = {
			self.closeButton.alpha = 1
			self.bodyText.alpha = 1
			self.layoutIfNeeded()
		}
		
		return (handler: animations, completion: nil, isAnimated: true)
	}
	
	internal func closeCellHandler() -> (handler: Handler?, completion: Handler?, isAnimated: Bool) {
		
		let animations = {
			
			self.closeButton.isHidden = true
			self.closeButton.alpha = 0
			
			self.bodyText.alpha = 0
			
			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant / 2
			
			self.findOutMoreLabel.animateText(text: "Find out more:", duration: 0.1)
			
			self.headerView.layer.cornerRadius = self.cornerRadius
			self.containerView.layer.cornerRadius = self.cornerRadius
		}
		
		return (handler: animations, completion: nil, isAnimated: true)
	}

	
	@IBAction func closeButtonPressed(_ sender: Any) {
		
		animateCloseCell()
	}
}

