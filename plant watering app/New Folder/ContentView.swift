import SwiftUI

struct ContentView: View {
    @State private var viewModel = PlantViewModel()
    @State private var showAddSheet = false

    var body: some View {
        Group {
            if viewModel.plants.isEmpty {
                EmptyStateView { showAddSheet = true }
            } else if viewModel.allDone {
                AllDoneView { showAddSheet = true }
            } else {
                TodayRemindersView(viewModel: viewModel) { showAddSheet = true }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            SetReminderView { plant in
                viewModel.add(plant)
            }
        }
    }
}

#Preview {
    ContentView()
}
