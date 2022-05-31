//
//  TextViewWithPlaceholder.swift
//  NSGames
//
//  Created by Rishat Latypov on 29.03.2022
//

import UIKit

class TextViewWithPlaceholder: UITextView, UITextViewDelegate {

    override var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                if let newValue = newValue {
                    self.addPlaceholder(newValue)
                }
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            if !self.text.isEmpty {
                placeholderLabel.removeFromSuperview()
            } else {
                addPlaceholder(placeholder ?? "")
            }
        }
    }

    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            let labelWidth = self.frame.width
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: self.textContainerInset.left + 2, y: self.textContainerInset.top, width: labelWidth, height: labelHeight)
            placeholderLabel.textAlignment = .left
        }
    }

    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.textAlignment = .center
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}
