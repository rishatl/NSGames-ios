//
//  OnboardingCoordinator.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.04.2022
//

import UIKit

protocol OnboardingCoordinatorProtocol: Coordinator {
    func animationFinished()
}

class OnboardingCoordinator: OnboardingCoordinatorProtocol {
    var mainCoordinator: MainCoordinator?

    func getStartViewController() -> UIViewController {
        let controller = OnboardingViewController()
        controller.coordinator = self
        return controller
    }

    func animationFinished() {
        mainCoordinator?.onboardingAnimationFinish()
    }
}
