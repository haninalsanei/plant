import SwiftUI

extension Color {
    static let plantGreen = Color(red: 0.24, green: 0.48, blue: 0.38)
    static let plantGreenBorder = Color(red: 0.55, green: 0.78, blue: 0.67)
}

struct PlantsHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Plants 🌱")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            Divider().overlay(Color.white.opacity(0.15))
        }
    }
}

// زر + العائم
struct AddFloatingButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.plantGreen, in: Circle())
                .overlay(Circle().stroke(Color.plantGreenBorder.opacity(0.6), lineWidth: 1))
        }
    }
}
