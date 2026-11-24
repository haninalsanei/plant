import Foundation
import SwiftData

/// ينشئ مخزن SwiftData اللي يتزامن مع iCloud (CloudKit).
enum PlantStore {
    static func makeContainer() -> ModelContainer {
        let schema = Schema([Plant.self])

        // automatic: يستخدم حاوية iCloud الموجودة في الـ entitlements.
        // لو المستخدم مو مسجّل في iCloud، التطبيق يشتغل محلي عادي ويتزامن أول ما يسجّل.
        let cloud = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)
        if let container = try? ModelContainer(for: schema, configurations: cloud) {
            return container
        }

        // احتياط: لو CloudKit رفض المخزن لأي سبب، نكمل بتخزين محلي بدل ما يطيح التطبيق
        let local = ModelConfiguration(schema: schema, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: schema, configurations: local)
        } catch {
            fatalError("Could not create the plant store: \(error)")
        }
    }

    /// مخزن في الذاكرة فقط، للـ Previews
    static func makePreviewContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: Plant.self, configurations: config)
        } catch {
            fatalError("Could not create the preview store: \(error)")
        }
    }
}
