import Foundation

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
struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: Room = .bedroom
    var light: LightRequirement = .fullSun
    var wateringFrequency: WateringFrequency = .everyDay
    var waterAmount: WaterAmount = .ml20to50
    var lastWateredDate: Date?
    /// تاريخ إضافة النبتة. اختياري عشان النباتات المحفوظة من قبل تنقرأ بدون مشاكل
    var createdDate: Date? = Date()
}

// MARK: - Today logic
extension Plant {
    var isDoneToday: Bool {
        guard let last = lastWateredDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    /// نحسب الدورة من آخر سقية، ولو ما انسقت أبداً من يوم إضافتها.
    /// مثلاً نبتة "Every 3 days" جديدة أول موعد لها بعد ٣ أيام من الحفظ.
    var cycleStartDate: Date? {
        lastWateredDate ?? createdDate
    }

    /// هل موعد سقيها اليوم (أو فات)؟
    var isDueToday: Bool {
        guard let start = cycleStartDate else { return true }
        let cal = Calendar.current
        let days = cal.dateComponents(
            [.day],
            from: cal.startOfDay(for: start),
            to: cal.startOfDay(for: Date())
        ).day ?? 0
        return days >= wateringFrequency.days
    }
}
