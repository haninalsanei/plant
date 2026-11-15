import SwiftUI

struct EmptyStateView: View {
    var onAddTapped: () -> Void

    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                PlantsHeader()

                Spacer()

                VStack(spacing: 20) {
                    Image("PlantPot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Start your plant journey!")
                        .font(.title3.bold())
                        .foregroundStyle(.white)

                    Text("Now all your plants will be in one place and\nwe will help you take care of them :)🪴")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleGray)

                    Button(action: onAddTapped) {
                        Text("Set Plant Reminder")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(width: 210, height: 38)
                            .background(Color.plantGreen, in: Capsule())
                            .overlay(Capsule().stroke(Color.plantGreenBorder.opacity(0.6), lineWidth: 1))
                    }
                    .padding(.top, 60)
                }
                .padding(.horizontal, 24)

                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EmptyStateView(onAddTapped: {})
}
