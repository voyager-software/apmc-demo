//
//  AppDelegate.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Internal

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setup()
        return true
    }

    // MARK: Private

    private func makeWindow(rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

    private func setup() {
        let navController = UINavigationController(rootViewController: EpisodeListController())
        self.makeWindow(rootViewController: navController)
    }
}
