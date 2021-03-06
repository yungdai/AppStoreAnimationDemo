//
//  ExpandedCellViewModel.swift
//  AppStoreAnimationDemo
//
//  Created by Yung Dai on 2019-05-07.
//

import UIKit

public struct ExpandedCellViewModel {

	let originalBounds: CGRect
	let originalCenter: CGPoint
	let openedBounds: CGRect
	let openedCenter: CGPoint
	let springDamping: CGFloat
	let springVelocity: CGFloat
	let animationDuration: TimeInterval
	
	weak var expandedCellCollectionProtocol: ExpandedCellCollectionProtocol?
	
	init( originalBounds: CGRect, originalCenter: CGPoint,
		 openedBounds: CGRect, openedCenter: CGPoint,
		 springDamping: CGFloat,
		 springVelocity: CGFloat, animationDuration: TimeInterval, expandedCellCollectionProtocol: ExpandedCellCollectionProtocol) {

		self.originalBounds = originalBounds
		self.originalCenter = originalCenter
		self.openedBounds = openedBounds
		self.openedCenter = openedCenter
		self.springDamping = springDamping
		self.springVelocity = springVelocity
		self.animationDuration = animationDuration
		self.expandedCellCollectionProtocol = expandedCellCollectionProtocol
	}
}
