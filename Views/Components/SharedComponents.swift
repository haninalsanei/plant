import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    static let plantGreen = Color(hex: 0x338069)
    static let plantGreenBorder = Color(red: 0.55, green: 0.78, blue: 0.67)
    static let plantMint = Color(hex: 0x29DFA8)
    static let progressGreen = Color(hex: 0x26C391)
    static let tagYellow = Color(hex: 0xCEDE89)
    static let deleteRed = Color(hex: 0xFF453A)
    static let subtitleGray = Color(hex: 0x9F9F91)
    static let sheetBackground = Color(hex: 0x1C1C1E)
    static let cardBackground = Color(hex: 0x2C2C2E)
}
struct PlantsHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Plants 🌱")
                    .font(.largeTitle.weight(.semibold))
                    .tracking(0.37)
//                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().overlay(Color.white.opacity(0.15))
        }
    }
}

struct AddFloatingButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(Color.plantGreen)
    }
}

