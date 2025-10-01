//
//  SceneDelegate.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let presenter = WindowPresenter(window: window)
        let appCoordinator = AppCoordinator(
            presenter: presenter,
            container: .init()
        )
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
}

