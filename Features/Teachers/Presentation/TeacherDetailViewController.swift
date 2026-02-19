//
//  TeacherDetailViewController.swift
//  Schedule
//

import UIKit

final class TeacherDetailViewController: UIViewController {

    private let teacher: Teacher

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        return sv
    }()

    private lazy var contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 16
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var headerCard: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.lessonCardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        iv.tintColor = .systemMint
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.titleFont
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var subjectLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.headlineFont
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var labelsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 8
        s.distribution = .fill
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.bodyFont
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    init(teacher: Teacher) {
        self.teacher = teacher
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = teacher.name
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        fillContent()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        headerCard.addSubview(iconView)
        headerCard.addSubview(nameLabel)
        headerCard.addSubview(subjectLabel)
        headerCard.addSubview(labelsStack)

        contentStack.addArrangedSubview(headerCard)
        contentStack.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: AppTheme.defaultPadding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: AppTheme.defaultPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -AppTheme.defaultPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -AppTheme.defaultPadding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -AppTheme.defaultPadding * 2),

            iconView.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            iconView.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),

            nameLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),

            subjectLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subjectLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            labelsStack.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 12),
            labelsStack.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: headerCard.trailingAnchor, constant: -16),
            labelsStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16)
        ])
    }

    private func fillContent() {
        nameLabel.text = teacher.name
        subjectLabel.text = teacher.subject ?? "—"

        // Лейблы: посещение и автомат
        if let attendance = teacher.marksAttendance, !attendance.isEmpty {
            let badge = makeBadge(text: attendanceText(attendance), color: .systemOrange)
            labelsStack.addArrangedSubview(badge)
        }
        if let hasAutomat = teacher.hasAutomat {
            let text = hasAutomat ? "Есть автомат" : "Нет автомата"
            let color: UIColor = hasAutomat ? .systemGreen : .systemGray
            let badge = makeBadge(text: text, color: color)
            labelsStack.addArrangedSubview(badge)
        }

        if let desc = teacher.description, !desc.isEmpty {
            descriptionLabel.text = desc
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.text = "Описание пока не добавлено."
            descriptionLabel.textColor = .secondaryLabel
        }
    }

    private func attendanceText(_ value: String) -> String {
        switch value.lowercased() {
        case "yes": return "Отмечает посещение"
        case "no": return "Не отмечает"
        case "sometimes": return "Иногда отмечает"
        default: return value
        }
    }

    private func makeBadge(text: String, color: UIColor) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = color.withAlphaComponent(0.2)
        container.layer.cornerRadius = AppTheme.labelCornerRadius

        let label = UILabel()
        label.text = text
        label.font = AppTheme.captionFont
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6)
        ])
        return container
    }
}
