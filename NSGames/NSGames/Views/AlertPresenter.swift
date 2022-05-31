//
//  File.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import UIKit

enum AlertPresenter {
    static func showAlert(controller: UIViewController, text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alert, animated: true)
    }
}
