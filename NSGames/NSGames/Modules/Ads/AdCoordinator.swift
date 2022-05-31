//
//  HomeCoordinator.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import UIKit

protocol AdsCoordinatorProtocol: Coordinator, SelectGameCoordinatorProtocol {
    func getStartViewController() -> UIViewController
    func goToDetailView(id: Int)
    func goToOfferView(id: Int)
    func close()
    func sendedOffer()
    func goToSelectGamesView(id: Int)
    func goToChat(messageId: String, username: String)
}

protocol SelectGameCoordinatorProtocol {
    func choosen(games: [Int])
}

class AdCoordinator: AdsCoordinatorProtocol {

    let navigationController = UINavigationController()
    let detailNavigationController = UINavigationController()
    let transitionManager = AdsTransitionManager()

    init() {
        let homeScreen = HomeScreenViewController()
        homeScreen.viewModel = HomeScreenViewModel(service: HomeScreenService(),
                                                   coordinator: self)
        navigationController.pushViewController(homeScreen, animated: true)
    }

    func getStartViewController() -> UIViewController {
        return navigationController
    }

    func goToDetailView(id: Int) {
        let controller = GameViewController()
        controller.viewModel = MockGameViewModel(service: GameService(),
                                                 coordinator: self,
                                                 id: id)
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.pushViewController(controller, animated: true)
            detailNavigationController.modalPresentationStyle = .overCurrentContext
            detailNavigationController.transitioningDelegate = transitionManager
            navigationController.present(detailNavigationController, animated: true, completion: nil)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
    }

    func goToOfferView(id: Int) {
        let controller = OfferViewController()
        controller.viewModel = MockOfferViewModel(service: OfferService(),
                                                  coordinator: self,
                                                  id: id)
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.pushViewController(controller, animated: true)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
    }

    func goToSelectGamesView(id: Int) {
        let controller = SelectGamesViewContoller()
        controller.viewModel = SelectGamesViewModel(service: SelectGamesService(),
                                                    coordinator: self,
                                                    id: id)
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.pushViewController(controller, animated: true)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
    }

    func goToChat(messageId: String, username: String) {
        let controller = ChatViewController()
        ChatFireBaseService.shared.otherUserName = username
        controller.viewModel = ChatViewModel(service: ChatFireBaseService.shared,
                                             id: messageId,
                                             title: username)
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.pushViewController(controller, animated: true)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
    }

    func choosen(games: [Int]) {
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.popViewController(animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            guard let controller = detailNavigationController.topViewController as? OfferViewController else { fatalError() }
            controller.viewModel?.selectedGames.value = games
        } else {
            guard let controller = navigationController.topViewController as? OfferViewController else { fatalError() }
            controller.viewModel?.selectedGames.value = games
        }
    }

    func close() {
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            detailNavigationController.transitioningDelegate = nil
            detailNavigationController.dismiss(animated: true, completion: nil)
        }
    }

    func sendedOffer() {
        navigationController.popViewController(animated: true)
        (navigationController.topViewController as? GameViewController)?.sended = true
    }
}
