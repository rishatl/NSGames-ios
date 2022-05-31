//
//  File.swift
//  NSGames
//
//  Created by Rishat Latypov on 14.03.2022
//

import UIKit

enum HomeScreenCellCollectionConstants {
    static let leftDistance: CGFloat = 14
    static let rightDistance: CGFloat = 14
    static let minimumLineSpacing: CGFloat = 14
    static let itemWidth = (UIScreen.main.bounds.width - HomeScreenCellCollectionConstants.leftDistance - HomeScreenCellCollectionConstants.rightDistance - (HomeScreenCellCollectionConstants.minimumLineSpacing)) / 2
}
