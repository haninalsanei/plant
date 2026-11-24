import SwiftUI
import SwiftData

@main struct MyApp: App {
    private let container: ModelContainer
    @State private var viewModel: PlantViewModel

    init() {
        let container = PlantStore.makeContainer()
        self.container = container
        _viewModel = State(initialValue: PlantViewModel(container: container))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
