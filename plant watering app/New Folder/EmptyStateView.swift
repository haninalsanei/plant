import SwiftUI

extension Color {
    static let plantGreen = Color(red: 0.24, green: 0.48, blue: 0.38)
    static let plantGreenBorder = Color(red: 0.55, green: 0.78, blue: 0.67)
}

struct EmptyStateView: View {
    var onAddTapped: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Divider().overlay(Color.white.opacity(0.15))

                Spacer()
                content
                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack {
            Text("My Plants 🌱")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var content: some View {
        VStack(spacing: 20) {
            Image("PlantPotWink")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            Text("Start your plant journey!")
                .font(.title3.bold())
                .foregroundStyle(.white)

            Text("Now all your plants will be in one place and\nwe will help you take care of them :)🪴")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)

            Button {
                onAddTapped()
            } label: {
                Text("Set Plant Reminder")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 40)
                    .background(Color.plantGreen, in: Capsule())
                    .overlay(Capsule().stroke(Color.plantGreenBorder.opacity(0.6), lineWidth: 1))
            }
            .padding(.top, 30)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    EmptyStateView(onAddTapped: {})
}
