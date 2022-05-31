//
//  AppDelegate.swift
//  NSGames
//
//  Created by Rishat Latypov on 03.03.2022
//

import UIKit
import Firebase
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainCoordinator = MainCoordinator()
        mainCoordinator?.start()
        FirebaseApp.configure()
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        return true
    }
}
