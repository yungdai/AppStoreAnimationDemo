//
//  CollectionViewController.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-01.
//

import UIKit
import UIExpandableCVCellKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController,  ExpandedCellCollectionProtocol {
	
	var collectionVC: UICollectionView?

	let cellsPerRow: CGFloat = 2
	let cellHeight: CGFloat = 150
	let springDamping: CGFloat = 0.8
	let springVelocity: CGFloat = 0.9
	let animationDuration: TimeInterval = 1
	
	var isOpen = false
	
	var statusBarShoudlBeHidden = false {
		didSet {
			UIView.animate(withDuration: 0.3) {
				self.setNeedsStatusBarAppearanceUpdate()
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// this is to ensure if you leave and come back that if the cell is opened you still won't be able to scroll
		collectionView.isScrollEnabled = (isOpen) ? false : true
		
		print("viewDidAppear isScrollEnabled: \(collectionView.isScrollEnabled)")
	}

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ExpandableCollectionViewCell else {
			return UICollectionViewCell() }
		
		let cellModel = ExpandedCellViewModel(originalBounds: cell.bounds,
											  originalCenter: cell.center,
											  openedBounds: collectionView.bounds,
											  openedCenter: collectionView.center,
											  springDamping: springDamping,
											  springVelocity: springVelocity,
											  animationDuration: animationDuration, expandedCellCollectionProtocol: self)

		cell.configure(with: cellModel)

        return cell
    }

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		// get the current cell
		guard let currentCell = collectionView.cellForItem(at: indexPath) as? ExpandableCollectionViewCell else { return }

		if !isOpen {
			currentCell.openCell()
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return statusBarShoudlBeHidden
	}
	
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .slide
	}
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let buffer: CGFloat = 10
		let cellWidth = (UIScreen.main.bounds.width - (buffer * cellsPerRow)) / cellsPerRow
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		return UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
	}
}

extension UICollectionView {
	
	func getCurrentCenterPoint() -> CGPoint {
		
		let collectionViewCenter = self.center
		let currentY = collectionViewCenter.y + self.contentOffset.y
		let currentCenter = CGPoint(x: collectionViewCenter.x, y: getYOffset(currentCenterY: currentY))
		
		print(self.contentOffset.y)
		
		return currentCenter
	}
	
	func getYOffset(currentCenterY: CGFloat) -> CGFloat {
		
		// the maxY offset would be the contentSizeHeight, but at the middle of the collectView.frame.height
		let maxY = self.contentSize.height - (self.frame.height / 2)
		
		let offset = CGFloat.returnNumberBetween(minimum: 0, maximum: maxY, inputValue: currentCenterY)
		
		return offset
	}
}

extension CGFloat {
	
	// handy helper that can be set an a CGFloat extension to make sure you get guidance for values between two numbers.
	static func returnNumberBetween(minimum smallerNumber: CGFloat, maximum largerNumber: CGFloat, inputValue value: CGFloat) -> CGFloat {
		
		let returnedFloat = minimum(largerNumber, maximum(smallerNumber, value))
		
		return returnedFloat
	}
}

extension UILabel {
	
	func animateText(text: String, duration: TimeInterval) {
		
		let animation = CATransition()
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.type = .fade
		animation.duration = duration
		
		self.layer.add(animation, forKey: nil)
		self.text = text
	}
}

extension UIApplication {
	
	/// Handy helper to get access to the statusBar's view
	var statusBarView: UIView? {
		guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
			return nil
		}
		return statusBarView
	}
}
