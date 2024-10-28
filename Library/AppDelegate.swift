//
//  AppDelegate.swift
//  Library
//
//  Created by Maxim on 21.10.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AppAppearance.setupAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        coordinator = AppCoordinator(navigationController: navController)
        coordinator?.start()

        return true
    }
}
