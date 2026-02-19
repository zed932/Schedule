//
//  TeachersViewController.swift
//  Schedule
//

import UIKit

final class TeachersViewController: UIViewController {

    private let viewModel: TeachersViewModel

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Преподаватели"
        l.font = AppTheme.titleFont
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .insetGrouped)
        t.dataSource = self
        t.delegate = self
        t.register(TeacherTableViewCell.self, forCellReuseIdentifier: teacherCellId)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 72
        return t
    }()

    init(viewModel: TeachersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Преподаватели"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        bindViewModel()
        viewModel.loadTeachers()
    }

    private func bindViewModel() {
        viewModel.onTeachersLoaded = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppTheme.defaultPadding),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension TeachersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.teachersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: teacherCellId, for: indexPath) as? TeacherTableViewCell else {
            return UITableViewCell()
        }
        if let teacher = viewModel.teacher(at: indexPath.row) {
            cell.configure(with: teacher)
        }
        return cell
    }
}

extension TeachersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let teacher = viewModel.teacher(at: indexPath.row) else { return }
        let detailVC = TeacherDetailViewController(teacher: teacher)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
