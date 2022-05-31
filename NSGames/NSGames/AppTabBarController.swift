//
//  AppTabBarController.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.03.2022
//

import UIKit

class AppTabBarController: UITabBarController {

    let mainCoordinator: MainCoordinator
    let adCoordinator = AdCoordinator()
    let chatCoordinator = ChatCoordinator()
    let profileCoordinator = ProfileCoordinator()
    let favoritesCoordinator = FavoritesCoordinator()
    let createAdCoordinator = CreateAdCoordinator()

    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        super.init(nibName: nil, bundle: nil)

        createAdCoordinator.tabBarCoordinator = self
        profileCoordinator.mainCoordinator = mainCoordinator
        let homeController = adCoordinator.getStartViewController()
        homeController.tabBarItem = UITabBarItem(title: L10n.tabBarMain,
                                                 image: UIImage(named: "house.fill"),
                                                 tag: 0)

        let chatController = chatCoordinator.getStartViewController()
        chatController.tabBarItem = UITabBarItem(title: L10n.tabBarChat,
                                                 image: UIImage(named: "paperplane.fill"),
                                                 tag: 0)

        let profileController = profileCoordinator.getStartViewController()
        profileController.tabBarItem = UITabBarItem(title: L10n.tabBarProfile,
                                                    image: UIImage(named: "person.crop.circle.fill"),
                                                    tag: 0)

        let favoritesController = favoritesCoordinator.getStartViewController()
        favoritesController.tabBarItem = UITabBarItem(title: L10n.tabBarFavorite,
                                                      image: UIImage(named: "star.fill"),
                                                      tag: 0)

        let createAdController = createAdCoordinator.getStartViewController()
        createAdController.tabBarItem = UITabBarItem(title: L10n.tabBarAd,
                                                     image: UIImage(named: "plus.app.fill"),
                                                     tag: 0)

        self.viewControllers = [homeController, favoritesController, createAdController, chatController, profileController]
    }

    func setProfileVC() {
        selectedIndex = 4
        guard let nc = self.viewControllers?[selectedIndex] as? UINavigationController,
              let vc = nc.topViewController as? ProfileViewController else { return }
        vc.updateData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
