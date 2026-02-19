//
//  LessonTableViewCell.swift
//  Schedule
//

import UIKit

let lessonCellId = "LessonTableViewCell"

final class LessonTableViewCell: UITableViewCell {

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.lessonCardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let typeBadge: PaddedLabel = {
        let l = PaddedLabel()
        l.font = AppTheme.captionFont
        l.textColor = .white
        l.textAlignment = .center
        l.layer.cornerRadius = AppTheme.labelCornerRadius
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.captionFont
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.headlineFont
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let detailLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.bodyFont
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let notePreviewLabel: UILabel = {
        let l = UILabel()
        l.font = AppTheme.captionFont
        l.textColor = .tertiaryLabel
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private var notePreviewHeightConstraint: NSLayoutConstraint?

    private lazy var addNoteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = .systemMint
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        return btn
    }()

    var onAddNoteTapped: (() -> Void)?

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
        cardView.addSubview(typeBadge)
        cardView.addSubview(timeLabel)
        cardView.addSubview(addNoteButton)
        cardView.addSubview(titleLabel)
        cardView.addSubview(detailLabel)
        cardView.addSubview(notePreviewLabel)

        addNoteButton.layer.cornerRadius = AppTheme.circleButtonCornerRadius

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.defaultPadding),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppTheme.defaultPadding),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            typeBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            typeBadge.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            typeBadge.heightAnchor.constraint(equalToConstant: 22),
            typeBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),

            addNoteButton.centerYAnchor.constraint(equalTo: typeBadge.centerYAnchor),
            addNoteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            addNoteButton.widthAnchor.constraint(equalToConstant: 30),
            addNoteButton.heightAnchor.constraint(equalToConstant: 30),

            timeLabel.centerYAnchor.constraint(equalTo: typeBadge.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: addNoteButton.leadingAnchor, constant: -8),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: typeBadge.trailingAnchor, constant: 8),

            titleLabel.topAnchor.constraint(equalTo: typeBadge.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            detailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            notePreviewLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 6),
            notePreviewLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            notePreviewLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            notePreviewLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
        notePreviewHeightConstraint = notePreviewLabel.heightAnchor.constraint(equalToConstant: 0)
        notePreviewHeightConstraint?.priority = .defaultHigh
        notePreviewHeightConstraint?.isActive = true
    }

    @objc private func addNoteTapped() {
        onAddNoteTapped?()
    }

    func configure(with slot: Slot, notePreview: String? = nil) {
        timeLabel.text = "\(slot.startTime) – \(slot.endTime)"

        if let lesson = slot.lesson {
            typeBadge.text = lesson.type.badgeTitle
            typeBadge.backgroundColor = AppTheme.color(for: lesson.type)
            typeBadge.isHidden = false
            titleLabel.text = lesson.name
            titleLabel.font = AppTheme.headlineFont
            detailLabel.text = "\(lesson.teacher.name) · ауд. \(lesson.room ?? "—")"
            detailLabel.textColor = .secondaryLabel
        } else {
            typeBadge.text = "Окно"
            typeBadge.backgroundColor = AppTheme.windowSlotColor
            typeBadge.isHidden = false
            titleLabel.text = slot.windowMessage ?? "Свободное время"
            titleLabel.font = AppTheme.bodyFont
            detailLabel.text = nil
            detailLabel.textColor = .tertiaryLabel
        }

        if let note = notePreview, !note.isEmpty {
            let preview = note.count > 60 ? String(note.prefix(57)) + "…" : note
            notePreviewLabel.text = "📝 \(preview)"
            notePreviewLabel.isHidden = false
            notePreviewHeightConstraint?.isActive = false
        } else {
            notePreviewLabel.text = nil
            notePreviewLabel.isHidden = true
            notePreviewHeightConstraint?.isActive = true
        }
    }
}

extension LessonType {
    var badgeTitle: String {
        switch self {
        case .lecture: return "Лекция"
        case .practice: return "Практика"
        case .lab: return "Лаба"
        }
    }
}
