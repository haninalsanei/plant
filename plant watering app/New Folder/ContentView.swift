import SwiftUI

struct ContentView: View {
    @State private var plants: [Plant] = []
    @State private var showAddSheet = false

    var body: some View {
        Group {
            if plants.isEmpty {
                EmptyStateView {
                    showAddSheet = true
                }
            } else {
                // مؤقت: نستبدله بالشاشة الرئيسية لاحقاً
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(plants) { plant in
                            Text("\(plant.name) • \(plant.room.displayName)")
                                .foregroundStyle(.white)
                        }

                        Button("Add") {
                            showAddSheet = true
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            SetReminderView { plant in
                plants.append(plant)
            }
        }
    }
}

#Preview {
    ContentView()
}
