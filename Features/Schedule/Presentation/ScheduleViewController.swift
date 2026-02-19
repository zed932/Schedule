//
//  ScheduleViewController.swift
//  Schedule
//

import UIKit

final class ScheduleViewController: UIViewController {

    // MARK: - Dependencies

    private var viewModel: ScheduleViewModel?
    private var coordinator: ScheduleCoordinatorProtocol?

    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = AppTheme.titleFont
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var scheduleTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.register(LessonTableViewCell.self, forCellReuseIdentifier: lessonCellId)
        table.register(ScheduleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ScheduleSectionHeaderView.reuseId)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.sectionHeaderTopPadding = 8
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        bindViewModel()
        viewModel?.loadSchedule()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleTable.reloadData()
    }

    // MARK: - Configuration

    func configure(viewModel: ScheduleViewModel, coordinator: ScheduleCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    // MARK: - Setup

    private func bindViewModel() {
        viewModel?.onScheduleLoaded = { [weak self] in
            self?.scheduleTable.reloadData()
        }
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(scheduleTable)
        scheduleTable.backgroundColor = .systemGroupedBackground
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppTheme.defaultPadding),
            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private static func weekdayTitle(_ weekday: Int) -> String {
        let names = ["", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
        guard weekday >= 1, weekday < names.count else { return "День \(weekday)" }
        return names[weekday]
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.currentDays.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel, section < viewModel.currentDays.count else { return 0 }
        return viewModel.visibleSlots(for: viewModel.currentDays[section]).count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel, section < viewModel.currentDays.count else { return nil }
        let day = viewModel.currentDays[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleSectionHeaderView.reuseId) as? ScheduleSectionHeaderView
        header?.configure(title: Self.weekdayTitle(day.weekday), date: day.date)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lessonCellId, for: indexPath) as? LessonTableViewCell else {
            return UITableViewCell()
        }
        guard let viewModel = viewModel, let coordinator = coordinator,
              indexPath.section < viewModel.currentDays.count else { return cell }
        let day = viewModel.currentDays[indexPath.section]
        let slots = viewModel.visibleSlots(for: day)
        guard indexPath.row < slots.count else { return cell }
        let slot = slots[indexPath.row]
        let key = slotKey(isOddWeek: viewModel.isOddWeek, weekday: day.weekday, pairNumber: slot.pairNumber)
        let noteText = viewModel.getNote(for: key)
        cell.configure(with: slot, notePreview: noteText)
        cell.onAddNoteTapped = { [weak self] in
            coordinator.showNoteModal(slotKey: key, initialText: noteText ?? "") { [weak self] _ in
                self?.scheduleTable.reloadData()
            }
        }
        return cell
    }
}

// MARK: - ScheduleSectionHeaderView

final class ScheduleSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseId = "ScheduleSectionHeaderView"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTheme.defaultPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -AppTheme.defaultPadding)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, date: String?) {
        titleLabel.text = title
        if let d = date, !d.isEmpty {
            dateLabel.text = " · \(d)"
            dateLabel.isHidden = false
        } else {
            dateLabel.text = nil
            dateLabel.isHidden = true
        }
    }
}
