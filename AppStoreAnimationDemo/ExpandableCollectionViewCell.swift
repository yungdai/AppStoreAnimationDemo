//
//  ExpandableCollectionViewCell.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-03.
//

import UIKit

public enum GestureFocus {
	case onCell, onCollection
}

class ExpandableCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var headerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var containterView: UIView!
	@IBOutlet weak var titleFont: UILabel!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var bodyText: UILabel!
	@IBOutlet weak var findOutMoreLabel: UILabel!
	
	var isOpen = false
	
	private var originalBounds: CGRect = CGRect.zero
	private var originalCenter: CGPoint = CGPoint.zero
	
	private var openedBounds: CGRect = CGRect.zero
	private var openedCenter: CGPoint = CGPoint.zero
	
	private var springDamping: CGFloat = 0.0
	private var springVelocity: CGFloat = 0.0
	
	private var animationDuration: TimeInterval = 0.0
	
	// threshold expressed in percentage of when the snapping should occure
	private var dragThreshold: CGFloat = 0.15

	private weak var collectionView: UICollectionView?
	
	private var viewModel: ExpandedCellViewModel?
	private var parentVC: CollectionViewController?
	private var panGesture = UIPanGestureRecognizer()

	func configure(with viewModel: ExpandedCellViewModel?) {

		guard let viewModel = viewModel else { return }
		isOpen = viewModel.isOpen
		originalBounds = viewModel.originalBounds
		originalCenter = viewModel.originalCenter
		openedBounds = viewModel.openedBounds
		springDamping = viewModel.springDamping
		springVelocity = viewModel.springVelocity
		animationDuration = viewModel.animationDuration
		collectionView = viewModel.collectionView
		parentVC = viewModel.parentVC
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)

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
	
	private func configureGesture(on focus: GestureFocus) {
		
		switch focus {
		case .onCell:
			panGesture.isEnabled = true
			collectionView?.isScrollEnabled = false
		case .onCollection:
			panGesture.isEnabled = false
			collectionView?.isScrollEnabled = true
		}
	}
	
	
	@objc
	private func cellGestured() {

		if isOpen {

			let distance = panGesture.translation(in: self).y
			
			switch panGesture.state {
				
			case .changed:

				if distance > 0 {
					if let height = collectionView?.bounds.height {
						
						if distance > height * dragThreshold {
							closeCell()
						} else {
							dragCell(panDistance: distance, collectionViewHeight: height)
						}
					}
				}

			case .ended:
				
				if let height = collectionView?.bounds.height {

					if distance < height * dragThreshold {
						
						snapBackCell()
					}
				}
				
			default:
				break
			}
		}
	}
	
	func openCell() {

		isOpen.toggle()
		parentVC?.statusBarShoudlBeHidden = true
		parentVC?.isOpen = true
		configureGesture(on: .onCell)
		
		UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {

			
			guard let collectionView = self.collectionView else { return }
			
			// fixes the offset when you first start because you will have an offset -0 for y
			if collectionView.contentOffset.y < 0 {
				collectionView.contentOffset.y = 0
			}
			
			self.closeButton.isHidden = false
			self.closeButton.alpha = 1
			
			self.bodyText.alpha = 1
			self.headerHeightConstraint.constant = self.headerHeightConstraint.constant * 2

			self.findOutMoreLabel.animateText(text: "New ways to open cells!", duration: self.animationDuration)
			
			let currentCenterPoint = collectionView.getCurrentCenterPoint()

			self.bounds = collectionView.bounds
			self.openedBounds = collectionView.bounds
			
			self.center = currentCenterPoint
			self.openedCenter = currentCenterPoint
			
			// ensures no cells below that will overlap this cell.
			collectionView.bringSubviewToFront(self)

			// use this because we are changing the height constraint for the image
			self.layoutIfNeeded()
		}, completion: nil)
		
	}
	
	private func dragCell(panDistance distance: CGFloat, collectionViewHeight height: CGFloat) {
		
		let percentageOfHeight = distance / height
		
		let dragWidth = openedBounds.width - (openedBounds.width * percentageOfHeight)
		
		let dragHeight = openedBounds
			.height - (openedBounds.height * percentageOfHeight)
		
		closeButton.alpha = 1 - percentageOfHeight
		bodyText.alpha = 1 - percentageOfHeight

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
		
		// this will move the center towards where the original was
		self.center = CGPoint(x: dragOriginX, y: dragOriginY)
		
		self.layoutIfNeeded()
	}
	
	private func snapBackCell() {
	
		print("snapped back")
		
		isOpen = true
		
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
			
			self.bounds = self.openedBounds
			self.center = self.openedCenter
			
			self.closeButton.alpha = 1
			self.bodyText.alpha = 1
			self.layoutIfNeeded()
		})
	}
	
	private func closeCell() {
		
		isOpen.toggle()
		parentVC?.statusBarShoudlBeHidden = false
		parentVC?.isOpen = false
		
		configureGesture(on: .onCollection)
		
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
			
			self.bounds = self.originalBounds
			self.center = self.originalCenter
			
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

