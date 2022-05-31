//
//  RoundedButton.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.03.2022
//

import UIKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.buttonBlue
        layer.cornerRadius = 14
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
