//
//  CollectionViewController.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-01.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
	
	var cellBounds = CGRect.zero
	let cellsPerRow: CGFloat = 2
	let cellHeight: CGFloat = 150
	var springDamping: CGFloat = 0.8
	var springVelocity: CGFloat = 0.9
	
	let animationDuration: TimeInterval = 1
	
	var isOpen = false

	var cellCenter = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// this is to ensure if you leave and come back that if the cell is opened you still won't be able to scroll
		if isOpen {
			collectionView.isScrollEnabled = false
		}
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
		
		cell.closeButton.alpha = 0
		cell.closeButton.isHidden = true
		cell.originalBounds = cell.bounds
		cell.originalCenter = cell.center
		cell.springDamping = springDamping
		cell.springVelocity = springVelocity
		cell.animationDuration = animationDuration
		cell.collectionView = collectionView

        return cell
    }

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// get the current cell
		guard let currentCell = collectionView.cellForItem(at: indexPath) as? ExpandableCollectionViewCell else { return }

		if !currentCell.isOpen {
			
			//TODO: Refactor to make it more efficient
			isOpen.toggle()
			currentCell.isOpen.toggle()
			cellBounds = currentCell.bounds
			cellCenter = currentCell.center

			UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {

				// fixes the offset when you first start because you will have an offset -0 for y
				if collectionView.contentOffset.y < 0 {
					collectionView.contentOffset.y = 0
				}
				
				currentCell.closeButton.isHidden = false
				currentCell.closeButton.alpha = 1

				currentCell.bodyText.alpha = 1
				currentCell.headerHeightConstraint.constant = currentCell.headerHeightConstraint.constant * 2
				
				// use this because we are changing the height constraint for the image
				currentCell.layoutIfNeeded()
				
				currentCell.findOutMoreLabel.animateText(text: "New ways to open cells!", duration: self.animationDuration)
				
				let currentCenterPoint = self.getCurrentCenterPoint()
				
				currentCell.bounds = collectionView.bounds
				currentCell.openedBounds = collectionView.bounds
				
				currentCell.center = currentCenterPoint
				currentCell.openedCenter = currentCenterPoint
				
				// ensures no cells below that will overlap this cell.
				collectionView.bringSubviewToFront(currentCell)

				// disable scrolling so you can't move the cell
				collectionView.isScrollEnabled = false
				
			}, completion: nil)
		} else {
			isOpen.toggle()
		}
	}
	
	private func getCurrentCenterPoint() -> CGPoint {

		let collectionViewCenter = collectionView.center
		let currentY = collectionViewCenter.y + collectionView.contentOffset.y
		let currentCenter = CGPoint(x: collectionViewCenter.x, y: getYOffset(currentCenterY: currentY))
		
		print(collectionView.contentOffset.y)
		
		return currentCenter
	}
	
	private func getYOffset(currentCenterY: CGFloat) -> CGFloat {

		// the maxY offset would be the contentSizeHeight, but at the middle of the collectView.frame.height
		let maxY = collectionView.contentSize.height - (collectionView.frame.height / 2)
		
		let offset = returnNumberBetween(minimum: 0, maximum: maxY, inputValue: currentCenterY)
		
		return offset
	}
	
	// handy helper that can be set an a CGFloat extension to make sure you get guidance for values between two numbers.
	func returnNumberBetween(minimum smallerNumber: CGFloat, maximum largerNumber: CGFloat, inputValue value: CGFloat) -> CGFloat {
		
		let returnedFloat = CGFloat.minimum(largerNumber, CGFloat.maximum(smallerNumber, value))
		
		return returnedFloat
	}
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let buffer: CGFloat = 10
		let cellWidth = (UIScreen.main.bounds.width - (buffer * cellsPerRow)) / cellsPerRow
		
		return CGSize(width: cellWidth, height: cellHeight)
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
