//
//  LoadingView.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.05.2022
//

import UIKit
import SnapKit

class LoadingView: UIView {
    let blurEffect = UIBlurEffect(style: .light)
    let activityIndicator = UIActivityIndicatorView()
    lazy var blurView = UIVisualEffectView(effect: blurEffect)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .none
        layer.cornerRadius = 14
        layer.masksToBounds = true

        self.addSubview(blurView)
        self.addSubview(activityIndicator)

        activityIndicator.startAnimating()

        blurView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
