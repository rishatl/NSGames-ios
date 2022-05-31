//
//  DataTextField.swift
//  NSGames
//
//  Created by Rishat Latypov on 03.03.2022
//

import UIKit

class DataTextField: UITextField {

    // MARK: - UI
    private let border = UIView()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)))
        font = UIFont.systemFont(ofSize: 18, weight: .medium)
        clearButtonMode = .whileEditing
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .next
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Public Methods

    func incorrectData(message: String) {
        attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        border.backgroundColor = .red
        text = ""
    }

    // MARK: - UITextField
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: bounds.height + 1.5, width: bounds.width, height: 1.5)
    }

    // MARK: - Private Methods
    private func setupUI() {
        borderStyle = .none
        addSubview(border)
        border.backgroundColor = .grayView
        border.isUserInteractionEnabled = false
    }
}
