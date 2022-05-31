//
//  File.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.03.2022
//

import Foundation

// Old observer version

public final class ObservableUI<T> {
    typealias Listener = (T) -> Void

    private var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
