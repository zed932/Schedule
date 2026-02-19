//
//  NoteModalViewController.swift
//  Schedule
//

import UIKit

final class NoteModalViewController: UIViewController {

    private let slotKey: String
    private let initialText: String
    private let saveNoteUseCase: SaveNoteUseCaseProtocol
    private let onSave: (String) -> Void

    init(
        slotKey: String,
        initialText: String,
        saveNoteUseCase: SaveNoteUseCaseProtocol,
        onSave: @escaping (String) -> Void
    ) {
        self.slotKey = slotKey
        self.initialText = initialText
        self.saveNoteUseCase = saveNoteUseCase
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = AppTheme.lessonCardBackground
        v.layer.cornerRadius = AppTheme.cardCornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Заметка к паре"
        l.font = AppTheme.titleFont
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = AppTheme.bodyFont
        tv.textColor = .label
        tv.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(white: 0.2, alpha: 1)
                : UIColor(white: 0.96, alpha: 1)
        }
        tv.layer.cornerRadius = AppTheme.smallCornerRadius
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        return tv
    }()

    private lazy var placeholderLabel: UILabel = {
        let l = UILabel()
        l.text = "Домашнее задание, пометка..."
        l.font = AppTheme.bodyFont
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Сохранить", for: .normal)
        btn.titleLabel?.font = AppTheme.headlineFont
        btn.backgroundColor = .systemMint
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = AppTheme.buttonCornerRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Отмена", for: .normal)
        btn.titleLabel?.font = AppTheme.bodyFont
        btn.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(white: 0.25, alpha: 1)
                : UIColor(white: 0.9, alpha: 1)
        }
        btn.setTitleColor(.label, for: .normal)
        btn.layer.cornerRadius = AppTheme.buttonCornerRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        textView.text = initialText
        placeholderLabel.isHidden = !initialText.isEmpty

        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)
        containerView.addSubview(saveButton)
        containerView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppTheme.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppTheme.defaultPadding),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 140),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16),

            cancelButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),

            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    @objc private func saveTapped() {
        let text = textView.text ?? ""
        saveNoteUseCase.execute(text: text, for: slotKey)
        onSave(text)
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NoteModalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !(textView.text ?? "").isEmpty
    }
}
