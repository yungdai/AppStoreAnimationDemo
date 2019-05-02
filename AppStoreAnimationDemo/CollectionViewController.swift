//
//  CollectionViewController.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-01.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
	
	var isOpen = false
	
	var cellBounds = CGRect.zero

	var cellCenter = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// get the current cell
		guard let currentCell = collectionView.cellForItem(at: indexPath) else { return }

		if !isOpen {

			cellBounds = currentCell.bounds
			cellCenter = currentCell.center

			UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {

				// fixes the offset when you first start because you will have an offset -0 for y
				if collectionView.contentOffset.y < 0 {
					collectionView.contentOffset.y = 0
				}
				
				currentCell.bounds = collectionView.bounds
				currentCell.center = self.getCurrentCenterPoint()


				// ensures no cells below that will overlap this cell.
				collectionView.bringSubviewToFront(currentCell)

				// disable scrolling so you can't move the cell
				collectionView.isScrollEnabled = false
				
			}, completion: nil)

			isOpen.toggle()
		} else {

			UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {

				currentCell.bounds = self.cellBounds
				currentCell.center = self.cellCenter
				
				// renable scrolling for the collectionView
				collectionView.isScrollEnabled = true
			})

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
		let cellWidth = (UIScreen.main.bounds.width - (buffer * 3)) / 3
		
		return CGSize(width: cellWidth, height: 100)
	}
}
