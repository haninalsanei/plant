import SwiftUI
import SwiftData
import CoreData
import Observation

@Observable
final class PlantViewModel {
    private(set) var plants: [Plant] = []

    @ObservationIgnored private let container: ModelContainer
    @ObservationIgnored private var context: ModelContext { container.mainContext }
    @ObservationIgnored private var remoteChangeTask: Task<Void, Never>?
    /// آخر نسخة جدولنا لها تذكيرات، عشان ما نعيد الجدولة إلا للنباتات اللي تغيّرت فعلاً
    @ObservationIgnored private var scheduled: [UUID: ReminderKey] = [:]

    private let legacyStorageKey = "savedPlants"

    init(container: ModelContainer) {
        self.container = container
        migrateFromUserDefaults()
        fetch()
        syncNotifications(force: true)
        observeRemoteChanges()
    }

    // MARK: - Today
    var todayPlants: [Plant] {
        // غير المكتملة أولاً ثم المكتملة، مع الحفاظ على الترتيب الأصلي داخل كل مجموعة
        let today = plants.filter { $0.isDueToday || $0.isDoneToday }
        return today.filter { !$0.isDoneToday } + today.filter { $0.isDoneToday }
    }

    var completedCount: Int {
        todayPlants.filter { $0.isDoneToday }.count
    }

    var progress: Double {
        todayPlants.isEmpty ? 0 : Double(completedCount) / Double(todayPlants.count)
    }

    /// True when you have plants and none of them still need water today.
    /// Covers both: everything due today is watered, or nothing is due today at all.
    var allDone: Bool {
        !plants.isEmpty && todayPlants.allSatisfy { $0.isDoneToday }
    }

    // MARK: - Actions
    func add(_ plant: Plant) {
        context.insert(plant)
        saveAndRefresh()
    }

    /// النبتة نفسها تعدّلت في شاشة التعديل، هنا نحفظ ونحدّث التذكيرات بس
    func update(_ plant: Plant) {
        saveAndRefresh()
    }

    func delete(_ plant: Plant) {
        context.delete(plant)
        saveAndRefresh()
    }

    func toggleWatered(_ plant: Plant) {
        plant.lastWateredDate = plant.isDoneToday ? nil : Date()
        // نعيد الجدولة عشان تبدأ الدورة من تاريخ السقي الجديد
        saveAndRefresh()
    }

    // MARK: - Storage
    private func saveAndRefresh() {
        do {
            try context.save()
        } catch {
            print("Failed to save plants: \(error)")
        }
        fetch()
        syncNotifications()
    }

    private func fetch() {
        let descriptor = FetchDescriptor<Plant>(sortBy: [SortDescriptor(\.createdDate)])
        plants = (try? context.fetch(descriptor)) ?? []
    }

    /// لما تجي تغييرات من iCloud (من جهاز ثاني مثلاً) نحدّث القائمة والتذكيرات
    private func observeRemoteChanges() {
        remoteChangeTask = Task { [weak self] in
            let changes = NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange)
            for await _ in changes {
                guard let self else { return }
                self.fetch()
                self.syncNotifications()
            }
        }
    }

    // MARK: - Notifications
    /// يجدول التذكيرات للنباتات الجديدة أو اللي تغيّر موعدها، ويلغي تذكيرات النباتات المحذوفة
    private func syncNotifications(force: Bool = false) {
        let current = Dictionary(plants.map { ($0.id, ReminderKey($0)) }, uniquingKeysWith: { first, _ in first })

        for (id, key) in current where force || scheduled[id] != key {
            NotificationManager.shared.schedule(key)
        }
        for id in scheduled.keys where current[id] == nil {
            NotificationManager.shared.cancel(id)
        }
        scheduled = current
    }

    // MARK: - Migration
    /// ننقل النباتات المحفوظة في UserDefaults (النسخة القديمة) إلى SwiftData مرة وحدة
    private func migrateFromUserDefaults() {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: legacyStorageKey) else { return }
        guard let legacy = try? JSONDecoder().decode([LegacyPlant].self, from: data) else {
            print("Could not read old plants, leaving them in UserDefaults")
            return
        }

        // نعطي كل نبتة تاريخ إضافة متسلسل عشان يبقى نفس الترتيب القديم
        let base = Date()
        for (index, old) in legacy.enumerated() {
            context.insert(Plant(
                id: old.id,
                name: old.name,
                room: old.room,
                light: old.light,
                wateringFrequency: old.wateringFrequency,
                waterAmount: old.waterAmount,
                lastWateredDate: old.lastWateredDate,
                createdDate: base.addingTimeInterval(Double(index))
            ))
        }

        do {
            try context.save()
            defaults.removeObject(forKey: legacyStorageKey)
        } catch {
            print("Failed to migrate plants: \(error)")
        }
    }
}

// MARK: - Previews
#if DEBUG
extension PlantViewModel {
    static func preview(plants: [Plant] = []) -> PlantViewModel {
        let container = PlantStore.makePreviewContainer()
        plants.forEach { container.mainContext.insert($0) }
        return PlantViewModel(container: container)
    }
}
#endif
