//
//  AppCoordinator.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit
import YandexMapKit

class AppCoordinator: NSObject {

    private var window: UIWindow?

    init(window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        self.window = window
    }

    func configure() {
        configureYandexMap()
        configureRootController()
    }

    private func configureYandexMap() {
        YMKMapKit.setApiKey(.yandexApiKey)
    }

    private func configureRootController() {
        window?.rootViewController = UINavigationController(rootViewController: MapViewController())
    }

}
