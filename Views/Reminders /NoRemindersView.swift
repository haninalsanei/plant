import SwiftUI

struct NoRemindersView: View {
    var onAddTapped: () -> Void

    var body: some View {
        ZStack {
    //        Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                PlantsHeader()
                Spacer()
                Text("No reminders set yet..")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
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
    NoRemindersView(onAddTapped: {})
}
