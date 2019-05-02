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
	
	var cellBounds = [IndexPath: CGRect]()

	var cellCenter = [IndexPath: CGPoint]()
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

			// save the previous bounds, might come in handy if you are going to open up a bunch of different cells at once
			cellBounds = [indexPath: currentCell.bounds]
			cellCenter = [indexPath: currentCell.center]

			let collectionViewCenter = collectionView.center
			
			UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
				currentCell.bounds = collectionView.bounds
				currentCell.center = CGPoint(x: collectionViewCenter.x, y: collectionViewCenter.y)

				collectionView.bringSubviewToFront(currentCell)

				// disable scrolling so you can't move the cell
				collectionView.isScrollEnabled = false
			}, completion: nil)

			isOpen.toggle()
		} else {

			UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {

				currentCell.bounds = self.cellBounds[indexPath] ?? CGRect.zero
				currentCell.center = self.cellCenter[indexPath] ?? CGPoint.zero
				
				// renable scrolling for the collectionView
				collectionView.isScrollEnabled = true
			})

			isOpen.toggle()
		}
	}
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let buffer: CGFloat = 10
		let cellWidth = (UIScreen.main.bounds.width - (buffer * 3)) / 3
		
		return CGSize(width: cellWidth, height: 100)
	}
}
