import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let reminderHour = 9
    /// عدد التذكيرات القادمة لكل نبتة (iOS يسمح بـ 64 إشعار معلّق كحد أقصى)
    private let batchCount = 5

    private override init() {
        super.init()
        center.delegate = self
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    // MARK: - Permission
    /// يطلب الصلاحية مرة وحدة فقط، وبعدها يرجع الحالة المحفوظة بدون ما يزعج المستخدم
    func requestPermission() async -> Bool {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
        default:
            return false
        }
    }

    // MARK: - Schedule
    /// يجدول تذكيرات النبتة بناءً على آخر مرة انسقت، مو على وقت فتح التطبيق.
    /// ياخذ نسخة من بيانات النبتة (مو النبتة نفسها) عشان ما نلمس نموذج SwiftData ممكن ينحذف أثناء الانتظار.
    func schedule(_ plant: ReminderKey) {
        Task {
            guard await requestPermission() else { return }
            await removePending(for: plant.id)

            let cal = Calendar.current
            let body = "Time to water \(plant.name) 💧"
            let start = firstReminderDate(for: plant, calendar: cal)

            for i in 0..<batchCount {
                guard let date = cal.date(byAdding: .day,
                                          value: i * plant.frequencyDays,
                                          to: start) else { continue }
                let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                await add(id: "\(plant.id.uuidString)-\(i)",
                          body: body,
                          trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false))
            }
        }
    }

    /// أول موعد تذكير: يوم السقي القادم الساعة ٩.
    /// لو النبتة ما انسقت أبداً أو موعدها فات، نذكّر في أقرب ساعة ٩ قادمة.
    private func firstReminderDate(for plant: ReminderKey, calendar cal: Calendar) -> Date {
        let now = Date()
        let nextReminderHour = cal.nextDate(
            after: now,
            matching: DateComponents(hour: reminderHour, minute: 0),
            matchingPolicy: .nextTime
        ) ?? now

        guard let last = plant.lastWateredDate,
              let dueDay = cal.date(byAdding: .day,
                                    value: plant.frequencyDays,
                                    to: cal.startOfDay(for: last)),
              let dueDate = cal.date(bySettingHour: reminderHour, minute: 0, second: 0, of: dueDay),
              dueDate > now
        else { return nextReminderHour }

        return dueDate
    }

    func cancel(_ plantID: UUID) {
        Task { await removePending(for: plantID) }
    }

    // MARK: - Helpers
    private func add(id: String, body: String, trigger: UNNotificationTrigger) async {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try? await center.add(request)
    }

    private func removePending(for plantID: UUID) async {
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(plantID.uuidString) }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    // MARK: - للتجربة فقط
    #if DEBUG
    func sendTest() {
        Task {
            guard await requestPermission() else { return }
            await add(id: "test",
                      body: "Test notification",
                      trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false))
        }
    }
    #endif
}

// MARK: - Reminder snapshot
/// البيانات اللي تحتاجها التذكيرات بس. لو تغيّر أي شي منها نعيد جدولة النبتة.
struct ReminderKey: Equatable, Sendable {
    let id: UUID
    let name: String
    let frequencyDays: Int
    let lastWateredDate: Date?

    init(_ plant: Plant) {
        id = plant.id
        name = plant.name
        frequencyDays = plant.wateringFrequency.days
        lastWateredDate = plant.lastWateredDate
    }
}
