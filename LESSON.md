# Урок: Верстка в UIKit и декодирование JSON

Этот урок привязан к твоему проекту Schedule. В нём разобраны основы верстки кодом (Auto Layout) и загрузка данных из `schedule.json` через `Codable`.

---

## Часть 1. Верстка в UIKit (Auto Layout)

### 1.1. Зачем нужны констрейнты

Во время выполнения у каждой `UIView` есть **frame** (x, y, width, height). Если ты не задаёшь его явно, система должна как-то его вычислить. **Auto Layout** как раз и решает: «где и какого размера будет view», через **констрейнты** (ограничения): «левый край привязан к левому краю родителя», «высота 100», «нижний край к верху другой view + 20» и т.д.

Правило: для каждой оси (горизонталь и вертикаль) у view должно быть **однозначно** определено:
- **Позиция** (например, left + centerY или centerX + centerY),
- **Размер** (width/height — явно или через содержимое/другие констрейнты).

Иначе получаются конфликты, предупреждения в консоли («Unable to simultaneously satisfy constraints») или «расплывшийся» layout.

---

### 1.2. `translatesAutoresizingMaskIntoConstraints = false`

По умолчанию у view включён **autoresizing mask**: система сама переводит его в констрейнты (например, «растягиваться по ширине/высоте»). Как только ты начинаешь задавать свои констрейнты, этот механизм мешает.

Поэтому для **любой** view, которую ты позиционируешь через Auto Layout, нужно выставить:

```swift
view.translatesAutoresizingMaskIntoConstraints = false
```

Иначе система будет подставлять старые autoresizing-констрейнты вместе с твоими → конфликты и неожиданное поведение.

**В твоём коде:** в `ProfileViewController` у `userProfileImage` и `userName` это уже стоит. В `ScheduleViewController` у `scheduleLabel` и `scheduleTable` этого не было — без этого таблица и лейбл могли вести себя странно.

---

### 1.3. Порядок действий при верстке кодом

1. **Создать view** (например, `UILabel()`, `UITableView()`).
2. **Добавить в иерархию:** `parentView.addSubview(childView)` — иначе констрейнты к ней не применяются и view не видна.
3. **Включить Auto Layout:** `childView.translatesAutoresizingMaskIntoConstraints = false`.
4. **Задать констрейнты** и активировать их (`NSLayoutConstraint.activate([...])`).

Пример (как у тебя в профиле):

```swift
view.addSubview(userProfileImage)
view.addSubview(userName)
// Оба уже с translatesAutoresizingMaskIntoConstraints = false в замыкании

NSLayoutConstraint.activate([
    userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    userProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    userProfileImage.widthAnchor.constraint(equalToConstant: 100),
    userProfileImage.heightAnchor.constraint(equalToConstant: 100),

    userName.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 20),
    userName.centerXAnchor.constraint(equalTo: userProfileImage.centerXAnchor)
])
```

У аватарки заданы: верх, центр по X, ширина, высота — по вертикали и горизонтали всё однозначно. У лейбла: верх относительно низа аватарки и центр по X; ширина/высота у `UILabel` определяются по тексту (intrinsic content size).

---

### 1.4. Anchors (якоря)

У каждой view есть «якоря» для привязки к другим view или к супервью:

- **Горизонталь:** `leadingAnchor`, `trailingAnchor`, `leftAnchor`, `rightAnchor`, `centerXAnchor`
- **Вертикаль:** `topAnchor`, `bottomAnchor`, `centerYAnchor`
- **Размер:** `widthAnchor`, `heightAnchor`

Часто используют `safeAreaLayoutGuide` у корневой view контроллера, чтобы не залезать под notch/островок:

```swift
view.safeAreaLayoutGuide.topAnchor
view.safeAreaLayoutGuide.bottomAnchor
```

Типичные констрейнты:

- «Сверху от safe area с отступом 20»:  
  `view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)`
- «По центру по горизонтали»:  
  `view.centerXAnchor.constraint(equalTo: parent.centerXAnchor)`
- «Фиксированная ширина 100»:  
  `view.widthAnchor.constraint(equalToConstant: 100)`
- «Слева и справа прижать к родителю с отступами»:  
  `view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16)`,  
  `view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16)`

Для таблицы, которая должна заполнять экран по ширине и по высоте, нужны все четыре стороны (например, top, bottom, leading, trailing к safe area или к view).

---

### 1.5. UIStackView

Если несколько view идут подряд (вертикально или горизонтально), удобно использовать **UIStackView**: он сам расставляет дочерние view и уменьшает количество констрейнтов.

- Ось: `.vertical` или `.horizontal`
- `spacing` — отступ между элементами
- `alignment`, `distribution` — выравнивание и распределение места

Констрейнты нужны уже не каждому дочернему view, а самому stack view (куда он привязан и какой у него размер). Внутри stack view всё считает система.

---

### 1.6. UITableView и верстка

- Таблице нужно задать **frame** или **констрейнты**, иначе она может иметь нулевой размер. Обычно привязывают top, bottom, leading, trailing к safe area (или к view).
- Ячейки переиспользуются: `dequeueReusableCell(withIdentifier:for:)`. Обязательно **зарегистрировать** ячейку (или класс, или nib) с тем же `identifier`.
- `UITableViewDataSource`: `numberOfRowsInSection`, `cellForRowAt` — откуда брать число строк и как заполнять ячейку.
- Если нужны секции (например, по дням недели), реализуешь `numberOfSections` и при необходимости `titleForHeaderInSection`.

В твоём приложении экран расписания как раз загружает данные из JSON и показывает их в таблице с секциями по дням.

---

## Часть 2. Декодирование данных из JSON

### 2.1. Зачем нужен Codable

В приложении данные часто приходят в виде JSON (с сервера или из локального файла). Нужно превратить этот JSON в удобные типы Swift: структуры и enum'ы. Протокол **Codable** = **Encodable** + **Decodable**: тип можно **закодировать** в данные (например, в JSON) и **декодировать** из данных.

Если все свойства модели совпадают с ключами в JSON и сами по себе Codable (String, Int, Bool, другие Codable-типы, массивы и словари таких типов), компилятор **автоматически** сгенерирует код кодирования/декодирования. Тебе достаточно объявить структуру и подписать её под `Codable`.

---

### 2.2. Структура JSON и модели в твоём проекте

Файл `schedule.json` устроен так:

- Корень — объект с ключами `"oddWeek"` и `"evenWeek"` (нечётная и чётная недели; пары в них могут отличаться).
- Каждая неделя: `"days"` (массив дней).
- День: `"weekday"`, `"date"`, `"slots"` (массив пар).
- Слот: `"pairNumber"`, `"startTime"`, `"endTime"`, `"lesson"` (объект или null), `"windowMessage"` (для окна — текст вроде «можно отдохнуть»).
- Урок: `"name"`, `"type"` (lecture/practice/lab), `"teacher"` (объект с `id`, `name`), `"room"`.

Этому соответствуют модели в проекте (см. `ScheduleModel.swift`, `LessonModel.swift`, `TeacherModel.swift`):

```swift
struct Schedule: Codable {
    let oddWeek: WeekSchedule
    let evenWeek: WeekSchedule
}

struct WeekSchedule: Codable {
    let days: [DaySchedule]
}

struct DaySchedule: Codable {
    let weekday: Int
    let date: String?
    let slots: [Slot]
}

struct Slot: Codable {
    let pairNumber: Int
    let startTime: String
    let endTime: String
    let lesson: Lesson?
    let windowMessage: String?  // подпись для окна
}

struct Lesson: Codable {
    let name: String
    let type: LessonType
    let teacher: Teacher
    let room: String?
}

struct Teacher: Codable {
    let id: String
    let name: String
}

enum LessonType: String, Codable {
    case lecture, practice, lab
}
```

Имена свойств в Swift **должны совпадать** с ключами в JSON (или нужно использовать `CodingKeys` для маппинга). Типы: числа → Int, строки → String, вложенные объекты → такие же Codable-структуры, массив → `[Element]`, необязательное поле → `Optional`.

---

### 2.3. JSONDecoder и загрузка из Bundle

Декодер из Foundation умеет превращать `Data` (сырые байты JSON) в твой тип:

```swift
let decoder = JSONDecoder()
let schedule = try decoder.decode(Schedule.self, from: data)
// schedule.weeks — массив Week, в каждой Week — days, в каждом Day — slots и т.д.
```

Файл `schedule.json` лежит в папке `Schedule/Resources/`. Чтобы он попал в приложение, его нужно включить в target: в Xcode выбери файл → в правой панели (File Inspector) отметь target «Schedule» в разделе «Target Membership». Тогда файл окажется в **Bundle** при сборке. Загрузить его можно так:

```swift
guard let url = Bundle.main.url(forResource: "schedule", withExtension: "json") else {
    print("Файл schedule.json не найден в бандле")
    return nil
}

let data = try Data(contentsOf: url)
let schedule = try JSONDecoder().decode(Schedule.self, from: data)
return schedule
```

- `Bundle.main` — бандл главного приложения.
- `url(forResource:withExtension:)` — путь к файлу по имени и расширению.
- `Data(contentsOf: url)` — прочитать файл в память (для больших файлов лучше использовать потоковые API, для маленького JSON так нормально).
- `decode(Schedule.self, from: data)` — разобрать JSON в структуру `Schedule`.

Если структура JSON не совпадает с моделями (лишние ключи обычно игнорируются, а вот отсутствующие обязательные поля или неверный тип вызовут ошибку), `decode` выбросит исключение. Его можно поймать и обработать (логировать, показать пользователю и т.д.).

---

### 2.4. Обработка ошибок

Типичный вариант: возвращать результат через enum или optional и обрабатывать неудачу.

```swift
func loadSchedule() -> Schedule? {
    guard let url = Bundle.main.url(forResource: "schedule", withExtension: "json") else {
        return nil
    }
    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Schedule.self, from: data)
    } catch {
        print("Ошибка загрузки расписания: \(error)")
        return nil
    }
}
```

Так экран может проверить: если `schedule == nil`, показать заглушку или сообщение; иначе — заполнить таблицу из `schedule.weeks` и слотов.

---

### 2.5. Дата и кастомные форматы

В твоём JSON дата приходит строкой (`"date": "2026-02-09"`). В моделях это `String?`. Если захочешь хранить `Date`, нужно настроить `JSONDecoder`:

```swift
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"
decoder.dateDecodingStrategy = .formatted(formatter)
```

Тогда свойства типа `Date` будут декодироваться по этому формату. Для текущего урока достаточно строки.

---

## Часть 3. Связываем верстку и данные

В `ScheduleViewController`:

1. **Загрузить расписание** при появлении экрана (например, в `viewDidLoad` или через отдельный сервис/лоадер).
2. **Сохранить** результат в свойство (например, `var schedule: Schedule?` или «развернутый» массив слотов по дням).
3. **В `numberOfSections`** вернуть количество дней (или недель — как задумаешь отображение).
4. **В `numberOfRowsInSection`** вернуть количество слотов в выбранном дне.
5. **В `cellForRowAt`** взять соответствующий `Slot`, подставить в ячейку название урока, время, преподавателя, аудиторию (и тип пары при желании).

Так таблица будет показывать реальные данные из `schedule.json`, а верстка экрана (констрейнты таблицы, заголовки секций) — пример применения Auto Layout на практике.

Дальше можно улучшать: кастомная ячейка с несколькими лейблами, секции с датой/днём недели, переключение недель и т.д. Основа — констрейнты для экрана и таблицы + одна точка загрузки JSON и одна модель `Schedule`, которую ты уже декодируешь через `Codable`.
