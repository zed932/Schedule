# Архитектура Schedule — Clean Architecture

Документ описывает целевую архитектуру проекта после рефакторинга: Clean Architecture + MVVM + Coordinator + DI.

---

## 1. Слои и зависимости

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Presentation (UI)                                                           │
│  ViewControllers, Views, ViewModels, Coordinators                            │
│  Зависит от: Domain, DI                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  Domain (Бизнес-логика)                                                      │
│  Entities, Use Cases, Repository Protocols                                   │
│  Зависит от: ничего (чистый Swift)                                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │
┌─────────────────────────────────────────────────────────────────────────────┐
│  Data (Инфраструктура)                                                        │
│  Repositories, Data Sources, DTO, Mappers                                    │
│  Зависит от: Domain                                                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Правило зависимостей:** зависимости направлены внутрь. Domain не знает о Data и Presentation.

---

## 2. Структура папок (целевая)

```
Schedule/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift              # Точка входа навигации
│
├── Core/                                  # Общие утилиты, тема
│   ├── Theme/
│   │   ├── AppTheme.swift
│   │   └── PaddedLabel.swift
│   ├── Extensions/
│   └── DI/
│       └── DependencyContainer.swift     # Сборка зависимостей
│
├── Features/                              # Модули по фичам
│   ├── Schedule/
│   │   ├── Domain/
│   │   │   ├── Entities/
│   │   │   │   ├── Schedule.swift
│   │   │   │   ├── Slot.swift
│   │   │   │   └── Lesson.swift
│   │   │   ├── UseCases/
│   │   │   │   ├── LoadScheduleUseCase.swift
│   │   │   │   └── GetCurrentWeekTypeUseCase.swift
│   │   │   └── Repositories/
│   │   │       └── ScheduleRepositoryProtocol.swift
│   │   ├── Data/
│   │   │   ├── Repositories/
│   │   │   │   └── ScheduleRepository.swift
│   │   │   ├── DataSources/
│   │   │   │   └── ScheduleLocalDataSource.swift
│   │   │   └── DTO/
│   │   │       └── ScheduleDTO.swift (если нужен маппинг)
│   │   └── Presentation/
│   │       ├── ScheduleCoordinator.swift
│   │       ├── ScheduleViewController.swift
│   │       ├── ScheduleViewModel.swift
│   │       ├── Views/
│   │       │   ├── LessonTableViewCell.swift
│   │       │   ├── ScheduleSectionHeaderView.swift
│   │       │   └── NoteModalViewController.swift
│   │       └── Note/
│   │           ├── NoteCoordinator.swift (или в Schedule)
│   │           ├── NoteModalViewController.swift
│   │           └── NoteViewModel.swift
│   │
│   ├── Teachers/
│   │   ├── Domain/
│   │   │   ├── Entities/
│   │   │   │   └── Teacher.swift
│   │   │   ├── UseCases/
│   │   │   │   └── LoadTeachersUseCase.swift
│   │   │   └── Repositories/
│   │   │       └── TeachersRepositoryProtocol.swift
│   │   ├── Data/
│   │   │   ├── Repositories/
│   │   │   │   └── TeachersRepository.swift
│   │   │   └── DataSources/
│   │   │       └── TeachersLocalDataSource.swift
│   │   └── Presentation/
│   │       ├── TeachersCoordinator.swift
│   │       ├── TeachersViewController.swift
│   │       ├── TeachersViewModel.swift
│   │       ├── TeacherDetailViewController.swift
│   │       └── Views/
│   │           └── TeacherTableViewCell.swift
│   │
│   ├── Profile/
│   │   ├── Domain/
│   │   │   ├── Entities/
│   │   │   │   └── User.swift
│   │   │   ├── UseCases/
│   │   │   │   └── LoadProfileUseCase.swift
│   │   │   └── Repositories/
│   │   │       └── ProfileRepositoryProtocol.swift
│   │   ├── Data/
│   │   │   └── ...
│   │   └── Presentation/
│   │       └── ...
│   │
│   └── Notes/                             # Отдельный домен заметок
│       ├── Domain/
│       │   ├── Entities/
│       │   │   └── Note.swift
│       │   ├── UseCases/
│       │   │   ├── GetNoteUseCase.swift
│       │   │   └── SaveNoteUseCase.swift
│       │   └── Repositories/
│       │       └── NotesRepositoryProtocol.swift
│       └── Data/
│           └── ...
│
└── Resources/
    ├── schedule.json
    ├── teachers.json
    ├── user.json
    └── Assets.xcassets/
```

---

## 3. Роли и именование классов

| Роль | Суффикс/Префикс | Пример | Описание |
|------|-----------------|--------|----------|
| **Entity** | — | `Schedule`, `Slot`, `Lesson` | Чистая бизнес-модель, без Codable/UI |
| **Use Case** | `UseCase` | `LoadScheduleUseCase` | Один сценарий использования |
| **Repository Protocol** | `Protocol` | `ScheduleRepositoryProtocol` | Контракт доступа к данным |
| **Repository** | `Repository` | `ScheduleRepository` | Реализация репозитория |
| **DataSource** | `DataSource` | `ScheduleLocalDataSource` | Низкоуровневый доступ (JSON, UserDefaults) |
| **ViewModel** | `ViewModel` | `ScheduleViewModel` | Состояние экрана, связь с Use Cases |
| **Coordinator** | `Coordinator` | `ScheduleCoordinator` | Навигация, создание экранов |
| **ViewController** | `ViewController` | `ScheduleViewController` | UI-контроллер, подписан на ViewModel |
| **View (кастомная)** | `View` | `ScheduleSectionHeaderView` | Переиспользуемый UI-компонент |
| **Cell** | `TableViewCell` | `LessonTableViewCell` | Ячейка таблицы |

---

## 4. Паттерны

### 4.1 Use Case (Interactor)

Один Use Case = один сценарий. Принимает зависимости через инициализатор.

```swift
// Domain/UseCases/LoadScheduleUseCase.swift
protocol LoadScheduleUseCaseProtocol {
    func execute() -> Schedule
}

final class LoadScheduleUseCase: LoadScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol

    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Schedule {
        repository.loadSchedule()
    }
}
```

### 4.2 Repository

Абстракция над источником данных. Presentation и Use Cases не знают, откуда данные (JSON, сеть, Core Data).

```swift
// Domain/Repositories/ScheduleRepositoryProtocol.swift
protocol ScheduleRepositoryProtocol {
    func loadSchedule() -> Schedule
}

// Data/Repositories/ScheduleRepository.swift
final class ScheduleRepository: ScheduleRepositoryProtocol {
    private let dataSource: ScheduleLocalDataSourceProtocol

    init(dataSource: ScheduleLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func loadSchedule() -> Schedule {
        dataSource.fetchSchedule()
    }
}
```

### 4.3 ViewModel (MVVM)

ViewModel владеет состоянием экрана. ViewController подписывается на изменения.

```swift
// Presentation/ScheduleViewModel.swift
final class ScheduleViewModel {
    // Output
    var onScheduleLoaded: (([DaySchedule]) -> Void)?
    var onError: ((String) -> Void)?

    private let loadScheduleUseCase: LoadScheduleUseCaseProtocol
    private let getWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol

    init(loadScheduleUseCase: LoadScheduleUseCaseProtocol,
         getWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol) {
        self.loadScheduleUseCase = loadScheduleUseCase
        self.getWeekTypeUseCase = getWeekTypeUseCase
    }

    func loadSchedule() {
        let schedule = loadScheduleUseCase.execute()
        let weekType = getWeekTypeUseCase.execute()
        let days = weekType.isOdd ? schedule.oddWeek.days : schedule.evenWeek.days
        onScheduleLoaded?(days)
    }
}
```

### 4.4 Coordinator

Coordinator создаёт экраны и управляет навигацией. Убирает навигационную логику из ViewController.

```swift
// Presentation/ScheduleCoordinator.swift
protocol ScheduleCoordinatorProtocol: AnyObject {
    func showNoteModal(slotKey: String, initialText: String, onSave: @escaping (String) -> Void)
}

final class ScheduleCoordinator: ScheduleCoordinatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showNoteModal(slotKey: String, initialText: String, onSave: @escaping (String) -> Void) {
        let vc = NoteModalViewController()
        vc.configure(slotKey: slotKey, initialText: initialText, onSave: onSave)
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true)
    }
}
```

### 4.5 Dependency Injection (DI)

Контейнер собирает зависимости. Никаких синглтонов в бизнес-логике.

```swift
// Core/DI/DependencyContainer.swift
final class DependencyContainer {
    // Data Sources
    lazy var scheduleDataSource = ScheduleLocalDataSource()
    lazy var notesDataSource = NotesUserDefaultsDataSource()

    // Repositories
    lazy var scheduleRepository: ScheduleRepositoryProtocol = ScheduleRepository(dataSource: scheduleDataSource)
    lazy var notesRepository: NotesRepositoryProtocol = NotesRepository(dataSource: notesDataSource)

    // Use Cases
    lazy var loadScheduleUseCase = LoadScheduleUseCase(repository: scheduleRepository)
    lazy var getWeekTypeUseCase = GetCurrentWeekTypeUseCase()
    lazy var getNoteUseCase = GetNoteUseCase(repository: notesRepository)
    lazy var saveNoteUseCase = SaveNoteUseCase(repository: notesRepository)

    // ViewModels (создаются при показе экрана)
    func makeScheduleViewModel() -> ScheduleViewModel {
        ScheduleViewModel(
            loadScheduleUseCase: loadScheduleUseCase,
            getWeekTypeUseCase: getWeekTypeUseCase,
            getNoteUseCase: getNoteUseCase,
            saveNoteUseCase: saveNoteUseCase
        )
    }
}
```

---

## 5. Добавление нового модуля (чеклист)

1. **Domain**
   - [ ] Создать `Features/<Module>/Domain/Entities/`
   - [ ] Создать `Features/<Module>/Domain/Repositories/<Module>RepositoryProtocol.swift`
   - [ ] Создать `Features/<Module>/Domain/UseCases/<Action>UseCase.swift`

2. **Data**
   - [ ] Создать `Features/<Module>/Data/DataSources/<Module>LocalDataSource.swift`
   - [ ] Создать `Features/<Module>/Data/Repositories/<Module>Repository.swift`
   - [ ] Зарегистрировать в `DependencyContainer`

3. **Presentation**
   - [ ] Создать `Features/<Module>/Presentation/<Module>Coordinator.swift`
   - [ ] Создать `Features/<Module>/Presentation/<Module>ViewModel.swift`
   - [ ] Создать `Features/<Module>/Presentation/<Module>ViewController.swift`
   - [ ] Добавить в `AppCoordinator` / `MainTabBarViewController`

4. **Интеграция**
   - [ ] Добавить таб/экран в `AppCoordinator`
   - [ ] Обновить `DOCUMENTATION.md`

---

## 6. Принципы

- **Single Responsibility:** один класс — одна зона ответственности
- **Dependency Inversion:** зависимость от протоколов, не от конкретных реализаций
- **Testability:** Use Cases и ViewModels тестируются без UI
- **Explicit over implicit:** зависимости передаются явно, не через синглтоны
- **Feature-first:** группировка по фичам, а не по типу (Models, Views)

---

## 7. Миграция

Миграция на Clean Architecture завершена. Для добавления новых модулей используйте чеклист в разделе 5.

---

## 8. Текущее состояние (19.02.2026)

- **Schedule:** асинхронная загрузка, WeekCounter для чётной/нечётной недели, заметки
- **Teachers:** список + карточка преподавателя (TeacherDetailViewController), данные из teachers.json
- **Profile:** данные из user.json
- **Notes:** UserDefaults, ключ — slotKey(isOddWeek, weekday, pairNumber)
- **Teacher:** кастомный init(from decoder:) с санитизацией строк (защита от EXC_BAD_ACCESS)
- **Swift 6:** декодирование JSON на MainActor (Schedule, Teachers)
