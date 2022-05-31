//
//  ShadowView.swift
//  NSGames
//
//  Created by Rishat Latypov on 29.03.2022
//

import UIKit

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 14
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
