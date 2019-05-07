//
//  ExpandedCellViewModel.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-07.
//

import UIKit

struct ExpandedCellViewModel {

	var isOpen = false
	let originalBounds: CGRect
	let originalCenter: CGPoint
	let openedBounds: CGRect
	let openedCenter: CGPoint
	let springDamping: CGFloat
	let springVelocity: CGFloat
	let animationDuration: TimeInterval
	weak var parentVC: CollectionViewController?
	weak var collectionView: UICollectionView?
	
	init(isOpen: Bool, originalBounds: CGRect, originalCenter: CGPoint,
		 openedBounds: CGRect, openedCenter: CGPoint,
		 springDamping: CGFloat,
		 springVelocity: CGFloat, animationDuration: TimeInterval,
		 collectionView: UICollectionView, parentVC: CollectionViewController) {
		
		self.isOpen = isOpen
		self.originalBounds = originalBounds
		self.originalCenter = originalCenter
		self.openedBounds = openedBounds
		self.openedCenter = openedCenter
		self.springDamping = springDamping
		self.springVelocity = springVelocity
		self.animationDuration = animationDuration
		self.collectionView = collectionView
		self.parentVC = parentVC
	}
	
}
