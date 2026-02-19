//
//  ProfileViewController.swift
//  Schedule
//

import UIKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel

    private var scrollView: UIScrollView?
    private var contentView: UIView?

    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        iv.tintColor = .systemMint
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.titleFont
        l.textColor = .label
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var groupLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.secondaryFont
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var groupCard: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.cardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var groupCardTitle: UILabel = {
        let l = UILabel()
        l.text = "Группа"
        l.font = AppTheme.captionFont
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var groupCardValue: UILabel = {
        let l = UILabel()
        l.font = AppTheme.headlineFont
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var emailCard: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.cardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var emailCardTitle: UILabel = {
        let l = UILabel()
        l.text = "Почта"
        l.font = AppTheme.captionFont
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var emailCardValue: UILabel = {
        let l = UILabel()
        l.font = AppTheme.bodyFont
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .systemGroupedBackground

        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        scrollView = sv

        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        contentView = cv

        setupLayout()
        bindViewModel()
        viewModel.loadProfile()
    }

    private func bindViewModel() {
        viewModel.onProfileLoaded = { [weak self] in
            self?.updateUI()
        }
    }

    private func updateUI() {
        nameLabel.text = viewModel.userName
        groupLabel.text = viewModel.userGroup
        groupCardValue.text = viewModel.userGroup
        emailCardValue.text = viewModel.userEmail
    }

    private func setupLayout() {
        guard let scrollView = scrollView, let contentView = contentView else { return }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(groupLabel)
        contentView.addSubview(groupCard)
        groupCard.addSubview(groupCardTitle)
        groupCard.addSubview(groupCardValue)
        contentView.addSubview(emailCard)
        emailCard.addSubview(emailCardTitle)
        emailCard.addSubview(emailCardValue)

        let padding = AppTheme.defaultPadding
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            groupLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            groupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            groupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            groupCard.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 20),
            groupCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            groupCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            groupCardTitle.topAnchor.constraint(equalTo: groupCard.topAnchor, constant: 12),
            groupCardTitle.leadingAnchor.constraint(equalTo: groupCard.leadingAnchor, constant: 12),
            groupCardValue.topAnchor.constraint(equalTo: groupCardTitle.bottomAnchor, constant: 4),
            groupCardValue.leadingAnchor.constraint(equalTo: groupCard.leadingAnchor, constant: 12),
            groupCardValue.trailingAnchor.constraint(equalTo: groupCard.trailingAnchor, constant: -12),
            groupCardValue.bottomAnchor.constraint(equalTo: groupCard.bottomAnchor, constant: -12),

            emailCard.topAnchor.constraint(equalTo: groupCard.bottomAnchor, constant: 12),
            emailCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            emailCardTitle.topAnchor.constraint(equalTo: emailCard.topAnchor, constant: 12),
            emailCardTitle.leadingAnchor.constraint(equalTo: emailCard.leadingAnchor, constant: 12),
            emailCardValue.topAnchor.constraint(equalTo: emailCardTitle.bottomAnchor, constant: 4),
            emailCardValue.leadingAnchor.constraint(equalTo: emailCard.leadingAnchor, constant: 12),
            emailCardValue.trailingAnchor.constraint(equalTo: emailCard.trailingAnchor, constant: -12),
            emailCardValue.bottomAnchor.constraint(equalTo: emailCard.bottomAnchor, constant: -12),

            contentView.bottomAnchor.constraint(equalTo: emailCard.bottomAnchor, constant: 24)
        ])
    }
}
