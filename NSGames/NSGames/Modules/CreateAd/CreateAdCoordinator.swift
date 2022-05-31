//
//  CreateAdCoordinator.swift
//  NSGames
//
//  Created by Rishat Latypov on 13.04.2022
//

import UIKit

protocol CreateAdCoordinatorProtocol: Coordinator, SelectGameCoordinatorProtocol {
    func goToSelectGamesView()
    func goToSelectGamesView(games: [Int])
    func goToProfilePage()
}

class CreateAdCoordinator: CreateAdCoordinatorProtocol {

    let navigationController = UINavigationController()
    var tabBarCoordinator: AppTabBarController?

    func getStartViewController() -> UIViewController {
        let controller = CreateAdViewController()
        controller.viewModel = CreateAdViewModel(service: CreateAdService(),
                                                 coordinator: self)
        navigationController.pushViewController(controller, animated: false)
        return navigationController
    }

    func goToSelectGamesView() {
        let controller = SelectGamesViewContoller()
        controller.viewModel = SelectGamesViewModel(service: SelectGamesService(),
                                                    coordinator: self,
                                                    id: nil)
        navigationController.pushViewController(controller, animated: true)
    }

    func goToSelectGamesView(games: [Int]) {
        let controller = SelectGamesViewContoller()
        controller.viewModel = SelectGamesViewModel(service: SelectGamesService(),
                                                    coordinator: self,
                                                    id: nil)
        controller.viewModel?.selected = games
        navigationController.pushViewController(controller, animated: true)
    }

    func goToProfilePage() {
        tabBarCoordinator?.setProfileVC()
    }

    func choosen(games: [Int]) {
        navigationController.popViewController(animated: true)
        if let viewModel = (navigationController.visibleViewController as? CreateAdViewController)?.viewModel {
            viewModel.selectedGames.value = games
        }
    }
}
