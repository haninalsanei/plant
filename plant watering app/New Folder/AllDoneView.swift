import SwiftUI

struct AllDoneView: View {
    var onAddTapped: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                PlantsHeader()

                Spacer()

                VStack(spacing: 14) {
                    Image("PlantPotWink")   // النبتة الغمزة
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(34)
                        .background(Circle().fill(Color(white: 0.07)))
                        .padding(.bottom, 12)

                    Text("All Done! 🎉")
                        .font(.title3.bold())
                        .foregroundStyle(.white)

                    Text("All Reminders Completed")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }

                Spacer()
                Spacer()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            AddFloatingButton(action: onAddTapped)
                .padding(.trailing, 24)
                .padding(.bottom, 24)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AllDoneView(onAddTapped: {})
}
