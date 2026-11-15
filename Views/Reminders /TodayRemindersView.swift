import SwiftUI

private let mint = Color.plantMint
private let tagYellow = Color.tagYellow
private let deleteRed = Color.deleteRed

struct TodayRemindersView: View {
    var viewModel: PlantViewModel
    var onAddTapped: () -> Void

    @State private var editingPlant: Plant?

    private var statusText: String {
        viewModel.completedCount == 0
        ? "Your plants are waiting for a sip 💦"
        : "\(viewModel.completedCount) of your plants feel loved today ✨"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                PlantsHeader()
                statusSection

                List {
                    ForEach(viewModel.todayPlants) { plant in
                        PlantRow(
                            plant: plant,
                            onToggle: { withAnimation { viewModel.toggleWatered(plant) } },
                            onEdit: { editingPlant = plant }
                        )
                        .listRowBackground(Color.black)
                        .listRowSeparatorTint(Color.white.opacity(0.15))
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                withAnimation { viewModel.delete(plant) }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .labelStyle(.iconOnly)
                            }
                            .tint(deleteRed)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            AddFloatingButton(action: onAddTapped)
                .padding(24)
        }
        .sheet(item: $editingPlant) { plant in
            SetReminderView(
                plant: plant,
                onSave: { viewModel.update($0) },
                onDelete: { viewModel.delete(plant) }
            )
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Status + progress
    private var statusSection: some View {
        VStack(spacing: 12) {
            Text(statusText)
                .font(.footnote)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color(red: 0.38, green: 0.73, blue: 0.62))
                        .frame(width: geo.size.width * viewModel.progress)
                }
            }
            .frame(height: 4)
            .animation(.easeInOut, value: viewModel.progress)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

// MARK: - Row
struct PlantRow: View {
    let plant: Plant
    let onToggle: () -> Void
    let onEdit: () -> Void

    private var done: Bool { plant.isDoneToday }

    var body: some View {
        HStack(spacing: 14) {
            // زر الـ check
            Button(action: onToggle) {
                Group {
                    if done {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.black, mint)
                    } else {
                        Image(systemName: "circle")
                            .foregroundStyle(.gray)
                    }
                }
                .font(.title2)
            }
            .buttonStyle(.plain)

            // محتوى الصف (الضغط عليه يفتح التعديل)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Label("in \(plant.room.displayName)", systemImage: "location")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)

                    Text(plant.name)
                        .font(.title3)
                        .foregroundStyle(done ? .gray : .white)

                    HStack(spacing: 8) {
                        tag(plant.light.displayName, icon: "sun.max", color: tagYellow)
                        tag(plant.waterAmount.displayName, icon: "drop", color: .white)
                    }
                    .opacity(done ? 0.5 : 1)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onEdit)
        }
        .padding(.vertical, 10)
    }

    private func tag(_ text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 10))
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
    }
}
