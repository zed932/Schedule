//
//  AppCoordinator.swift
//  Schedule
//
//  Корневой координатор приложения. Создаёт главный экран (Tab Bar) и его зависимости.
//

import UIKit

final class AppCoordinator {

    private let container = DependencyContainer.shared

    func makeRootViewController() -> UIViewController {
        MainTabBarViewController(container: container)
    }
}
