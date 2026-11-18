import SwiftUI

/// تظهر بعد ما يكمّل المستخدم الترحيب ثم يحذف كل نباتاته
struct NoRemindersSetView: View {
    var onAddTapped: () -> Void

    var body: some View {
        ZStack {
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
    }
}

#Preview {
    NoRemindersSetView(onAddTapped: {})
        .preferredColorScheme(.dark)
}
