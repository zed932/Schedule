//
//  MainTabBarViewController.swift
//  Schedule
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        let profileVC = ProfileViewController(viewModel: container.makeProfileViewModel())
        let teachersVC = TeachersViewController(viewModel: container.makeTeachersViewModel())

        let scheduleVC = container.makeScheduleViewController()

        // Расписание первым — открывается при входе в приложение
        let viewControllers = [
            wrapInNav(scheduleVC, title: "Расписание", image: "calendar"),
            wrapInNav(teachersVC, title: "Преподаватели", image: "person.2.fill"),
            wrapInNav(profileVC, title: "Профиль", image: "person.circle.fill")
        ]

        // Присваиваем массив экранов — без этой строки таб-бар пустой!
        self.viewControllers = viewControllers

        // Внешний вид таб-бара (цвет выбранной иконки / невыбранной)
        tabBar.tintColor = .systemMint
        tabBar.unselectedItemTintColor = .gray
    }

    private func wrapInNav(_ vc: UIViewController, title: String, image: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: 0)
        return nav
    }
}
