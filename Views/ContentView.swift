import SwiftUI

struct ContentView: View {
    @State private var viewModel = PlantViewModel()
    @State private var showAddSheet = false
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    var body: some View {
        Group {
            if viewModel.plants.isEmpty && !hasOnboarded {
                EmptyStateView { showAddSheet = true }          // أول استخدام
            } else if viewModel.plants.isEmpty {
                NoRemindersSetView { showAddSheet = true }      // حذف كل النباتات
            } else if viewModel.allDone {
                AllDoneView { showAddSheet = true }             // انسقت كلها أو ما فيه شي موعده اليوم
            } else {
                TodayRemindersView(viewModel: viewModel) { showAddSheet = true }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            SetReminderView { plant in
                viewModel.add(plant)
                hasOnboarded = true
            }
        }
        .onAppear {
            // للمستخدمين اللي عندهم نباتات محفوظة من قبل هذا التحديث
            if !viewModel.plants.isEmpty { hasOnboarded = true }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
