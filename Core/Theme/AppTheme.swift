import UIKit

enum AppTheme {

    // MARK: - Цвета по типу занятия (адаптируются к светлой/тёмной теме)

    static var lectureColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
                : UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 1.0)
        }
    }

    static var practiceColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.2, green: 0.7, blue: 0.4, alpha: 1.0)
                : UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
        }
    }

    static var labColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1.0)
                : UIColor(red: 0.95, green: 0.6, blue: 0.2, alpha: 1.0)
        }
    }

    static var windowSlotColor: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.systemGray
                : UIColor.systemGray2
        }
    }

    static var cardBackground: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.15, alpha: 1.0)
                : UIColor(white: 0.98, alpha: 1.0)
        }
    }

    static var lessonCardBackground: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.12, alpha: 1.0)
                : UIColor.white
        }
    }

    static func color(for type: LessonType) -> UIColor {
        switch type {
        case .lecture: return lectureColor
        case .practice: return practiceColor
        case .lab: return labColor
        }
    }

    // MARK: - Константы вёрстки

    static let cardCornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let defaultPadding: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 10
    static let labelCornerRadius: CGFloat = 10
    static let circleButtonCornerRadius: CGFloat = 15
    static let badgeHorizontalPadding: CGFloat = 12
}

// MARK: - Типографика

extension AppTheme {
    static var titleFont: UIFont { UIFont.systemFont(ofSize: 22, weight: .bold) }
    static var headlineFont: UIFont { UIFont.systemFont(ofSize: 17, weight: .semibold) }
    static var bodyFont: UIFont { UIFont.systemFont(ofSize: 15, weight: .regular) }
    static var secondaryFont: UIFont { UIFont.systemFont(ofSize: 15, weight: .regular) }
    static var captionFont: UIFont { UIFont.systemFont(ofSize: 12, weight: .medium) }
    static var lightLargeFont: UIFont { UIFont.systemFont(ofSize: 20, weight: .light) }
}
