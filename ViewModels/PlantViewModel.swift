import SwiftUI
import Observation

@Observable
final class PlantViewModel {
    private(set) var plants: [Plant] = []
    private let storageKey = "savedPlants"

    init() {
        load()
        NotificationManager.shared.rescheduleAll(plants)
    }

    // MARK: - Today
    var todayPlants: [Plant] {
        plants.filter { $0.isDueToday || $0.isDoneToday }
    }

    var completedCount: Int {
        todayPlants.filter { $0.isDoneToday }.count
    }

    var progress: Double {
        todayPlants.isEmpty ? 0 : Double(completedCount) / Double(todayPlants.count)
    }

    var allDone: Bool {
        !todayPlants.isEmpty && todayPlants.allSatisfy { $0.isDoneToday }
    }

    // MARK: - Actions
    func add(_ plant: Plant) {
        plants.append(plant)
        save()
        NotificationManager.shared.schedule(plant)
    }

    func update(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index] = plant
        save()
        NotificationManager.shared.schedule(plant)
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        save()
        NotificationManager.shared.cancel(plant)
    }

    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[index].lastWateredDate = plants[index].isDoneToday ? nil : Date()
        save()
    }

    // MARK: - Storage
    private func save() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Plant].self, from: data) else { return }
        plants = saved
    }
}
