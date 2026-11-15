import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let reminderHour = 9
    private let batchCount = 4

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
    func requestPermission() async -> Bool {
        (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    // MARK: - Schedule
    func schedule(_ plant: Plant) {
        Task {
            guard await requestPermission() else { return }
            await removePending(for: plant)

            let cal = Calendar.current
            let body = "Time to water \(plant.name) 💧"

            switch plant.wateringFrequency {
            case .everyDay:
                var comps = DateComponents()
                comps.hour = reminderHour
                await add(id: "\(plant.id.uuidString)-0",
                          body: body,
                          trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: true))

            case .weekly:
                var comps = DateComponents()
                comps.weekday = cal.component(.weekday, from: Date())
                comps.hour = reminderHour
                await add(id: "\(plant.id.uuidString)-0",
                          body: body,
                          trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: true))

            default:
                // كل ٢ أو ٣ أو ١٠ أو ١٤ يوم: نجدول عدة تذكيرات قادمة
                let start = cal.nextDate(
                    after: Date(),
                    matching: DateComponents(hour: reminderHour),
                    matchingPolicy: .nextTime
                ) ?? Date()

                for i in 0..<batchCount {
                    guard let date = cal.date(byAdding: .day,
                                              value: i * plant.wateringFrequency.days,
                                              to: start) else { continue }
                    let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    await add(id: "\(plant.id.uuidString)-\(i)",
                              body: body,
                              trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false))
                }
            }
        }
    }

    func cancel(_ plant: Plant) {
        Task { await removePending(for: plant) }
    }

    func rescheduleAll(_ plants: [Plant]) {
        plants.forEach { schedule($0) }
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

    private func removePending(for plant: Plant) async {
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(plant.id.uuidString) }
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
