import SwiftUI

struct EmptyStateView: View {
    var onAddTapped: () -> Void

    var body: some View {
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
                }
                .buttonStyle(.glassProminent)
                .tint(Color.plantGreen)
                .padding(.top, 60)
            }
            .padding(.horizontal, 24)

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    EmptyStateView(onAddTapped: {})
        .preferredColorScheme(.dark)
}
