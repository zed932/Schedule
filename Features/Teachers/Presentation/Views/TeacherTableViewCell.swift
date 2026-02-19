//
//  TeacherTableViewCell.swift
//  Schedule
//

import UIKit

let teacherCellId = "TeacherTableViewCell"

final class TeacherTableViewCell: UITableViewCell {

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.lessonCardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        iv.tintColor = .systemMint
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.headlineFont
        l.textColor = .label
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subjectLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.secondaryFont
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(subjectLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.defaultPadding),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppTheme.defaultPadding),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            subjectLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            subjectLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            subjectLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with teacher: Teacher) {
        // Явное копирование строк, чтобы избежать EXC_BAD_ACCESS при повреждённых данных из JSON
        nameLabel.text = String(teacher.name)
        subjectLabel.text = teacher.subject.map { String($0) } ?? "-"
    }
}
