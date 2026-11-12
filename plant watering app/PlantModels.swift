import Foundation

// MARK: - Room
enum Room: String, CaseIterable, Identifiable, Codable {
    case bedroom, livingRoom, kitchen, balcony, bathroom

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
    case fullSun, partialSun, lowLight

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
    case everyDay, every2Days, every3Days, weekly, every10Days, every2Weeks

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
    case ml20to50, ml50to100, ml100to200, ml200to300

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
    var lastWateredDate: Date? = nil
}
