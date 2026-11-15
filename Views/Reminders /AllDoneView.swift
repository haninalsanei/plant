import SwiftUI

struct AllDoneView: View {
    var onAddTapped: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            PlantsHeader()

            Spacer()

            VStack(spacing: 14) {
                Image("PlantPotWink")   // النبتة الغمزة
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(34)
                    .background(Circle().fill(Color.primary.opacity(0.06)))
                    .padding(.bottom, 12)

                Text("All Done! 🎉")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)

                Text("All Reminders Completed")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            AddFloatingButton(action: onAddTapped)
                .padding(.trailing, 24)
                .padding(.bottom, 24)
        }
    }
}

#Preview {
    AllDoneView(onAddTapped: {})
}
