//
//  GrayLabel.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.03.2022
//

import UIKit

class GrayLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 15)
        textColor = .grayLabel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
