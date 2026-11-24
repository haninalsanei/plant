import Foundation
import SwiftData

// MARK: - Room
enum Room: String, CaseIterable, Identifiable, Codable {
    case bedroom = "bedroom"
    case livingRoom = "livingRoom"
    case kitchen = "kitchen"
    case balcony = "balcony"
    case bathroom = "bathroom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bedroom: "Bedroom"
        case .livingRoom: "Living Room"
        case .kitchen: "Kitchen"
        case .balcony: "Balcony"
        case .bathroom: "Bathroom"
        }
    }

    var icon: String {
        switch self {
        case .bedroom: "bed.double"
        case .livingRoom: "sofa"
        case .kitchen: "fork.knife"
        case .balcony: "tree"
        case .bathroom: "shower"
        }
    }
}

// MARK: - Light
enum LightRequirement: String, CaseIterable, Identifiable, Codable {
    case fullSun = "fullSun"
    case partialSun = "partialSun"
    case lowLight = "lowLight"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fullSun: "Full sun"
        case .partialSun: "Partial sun"
        case .lowLight: "Low light"
        }
    }
}

// MARK: - Watering Frequency
enum WateringFrequency: String, CaseIterable, Identifiable, Codable {
    case everyDay = "everyDay"
    case every2Days = "every2Days"
    case every3Days = "every3Days"
    case weekly = "weekly"
    case every10Days = "every10Days"
    case every2Weeks = "every2Weeks"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .everyDay: "Every day"
        case .every2Days: "Every 2 days"
        case .every3Days: "Every 3 days"
        case .weekly: "Once a week"
        case .every10Days: "Every 10 days"
        case .every2Weeks: "Every 2 weeks"
        }
    }

    var days: Int {
        switch self {
        case .everyDay: 1
        case .every2Days: 2
        case .every3Days: 3
        case .weekly: 7
        case .every10Days: 10
        case .every2Weeks: 14
        }
    }
}

// MARK: - Water Amount
enum WaterAmount: String, CaseIterable, Identifiable, Codable {
    case ml20to50 = "ml20to50"
    case ml50to100 = "ml50to100"
    case ml100to200 = "ml100to200"
    case ml200to300 = "ml200to300"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ml20to50: "20-50 ml"
        case .ml50to100: "50-100 ml"
        case .ml100to200: "100-200 ml"
        case .ml200to300: "200-300 ml"
        }
    }
}

// MARK: - Plant
/// نموذج SwiftData ويتزامن مع iCloud عن طريق CloudKit.
/// شروط CloudKit: كل خاصية لها قيمة افتراضية (أو اختيارية)، وما نستخدم `@Attribute(.unique)`.
/// نحفظ الـ enums كنص (rawValue) عشان التخزين يكون بسيط ويتحمل أي تغيير مستقبلي.
@Model
final class Plant {
    var id: UUID = UUID()
    var name: String = ""
    var roomRaw: String = Room.bedroom.rawValue
    var lightRaw: String = LightRequirement.fullSun.rawValue
    var frequencyRaw: String = WateringFrequency.everyDay.rawValue
    var amountRaw: String = WaterAmount.ml20to50.rawValue
    var lastWateredDate: Date?
    /// نستخدمه للترتيب بس، عشان القائمة تحافظ على ترتيب الإضافة
    var createdDate: Date = Date()

    init(
        id: UUID = UUID(),
        name: String,
        room: Room = .bedroom,
        light: LightRequirement = .fullSun,
        wateringFrequency: WateringFrequency = .everyDay,
        waterAmount: WaterAmount = .ml20to50,
        lastWateredDate: Date? = nil,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.roomRaw = room.rawValue
        self.lightRaw = light.rawValue
        self.frequencyRaw = wateringFrequency.rawValue
        self.amountRaw = waterAmount.rawValue
        self.lastWateredDate = lastWateredDate
        self.createdDate = createdDate
    }

    var room: Room {
        get { Room(rawValue: roomRaw) ?? .bedroom }
        set { roomRaw = newValue.rawValue }
    }

    var light: LightRequirement {
        get { LightRequirement(rawValue: lightRaw) ?? .fullSun }
        set { lightRaw = newValue.rawValue }
    }

    var wateringFrequency: WateringFrequency {
        get { WateringFrequency(rawValue: frequencyRaw) ?? .everyDay }
        set { frequencyRaw = newValue.rawValue }
    }

    var waterAmount: WaterAmount {
        get { WaterAmount(rawValue: amountRaw) ?? .ml20to50 }
        set { amountRaw = newValue.rawValue }
    }
}

// MARK: - Legacy (UserDefaults)
/// الشكل القديم اللي كان محفوظ في UserDefaults، نستخدمه مرة وحدة عشان ننقل البيانات لـ SwiftData
struct LegacyPlant: Codable {
    var id: UUID
    var name: String
    var room: Room
    var light: LightRequirement
    var wateringFrequency: WateringFrequency
    var waterAmount: WaterAmount
    var lastWateredDate: Date?
}

// MARK: - Today logic
extension Plant {
    var isDoneToday: Bool {
        guard let last = lastWateredDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    /// هل موعد سقيها اليوم (أو فات)؟
    /// النبتة الجديدة اللي ما انسقت أبداً تطلع في قائمة اليوم على طول.
    var isDueToday: Bool {
        guard let start = lastWateredDate else { return true }
        let cal = Calendar.current
        let days = cal.dateComponents(
            [.day],
            from: cal.startOfDay(for: start),
            to: cal.startOfDay(for: Date())
        ).day ?? 0
        return days >= wateringFrequency.days
    }
}
