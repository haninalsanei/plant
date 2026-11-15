import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) private var dismiss

    private let existing: Plant?
    private let onSave: (Plant) -> Void
    private let onDelete: (() -> Void)?

    @State private var name: String
    @State private var room: Room
    @State private var light: LightRequirement
    @State private var frequency: WateringFrequency
    @State private var amount: WaterAmount

    init(
        plant: Plant? = nil,
        onSave: @escaping (Plant) -> Void = { _ in },
        onDelete: (() -> Void)? = nil
    ) {
        self.existing = plant
        self.onSave = onSave
        self.onDelete = onDelete
        _name = State(initialValue: plant?.name ?? "")
        _room = State(initialValue: plant?.room ?? .bedroom)
        _light = State(initialValue: plant?.light ?? .fullSun)
        _frequency = State(initialValue: plant?.wateringFrequency ?? .everyDay)
        _amount = State(initialValue: plant?.waterAmount ?? .ml20to50)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 28) {
            topBar
            nameField

            card {
                pickerRow("Room", icon: "location", selection: $room) { $0.displayName }
                Divider().overlay(Color.white.opacity(0.1))
                pickerRow("Light", icon: "sun.max", selection: $light) { $0.displayName }
            }

            card {
                pickerRow("Watering Days", icon: "drop", selection: $frequency) { $0.displayName }
                Divider().overlay(Color.white.opacity(0.1))
                pickerRow("Water", icon: "drop", selection: $amount) { $0.displayName }
            }

            if onDelete != nil {
                Button {
                    onDelete?()
                    dismiss()
                } label: {
                    Text("Delete Reminder")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0.93, green: 0.33, blue: 0.31))
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color(white: 0.18), in: Capsule())
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .background(Color(white: 0.11).ignoresSafeArea())
        .preferredColorScheme(.dark)
        .presentationBackground(Color(white: 0.11))
    }

    // MARK: - Top bar
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color(white: 0.2), in: Circle())
            }

            Spacer()

            Text("Set Reminder")
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()

            Button {
                save()
            } label: {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.plantGreen, in: Circle())
                    .opacity(canSave ? 1 : 0.4)
            }
            .disabled(!canSave)
        }
    }

    // MARK: - Name field
    private var nameField: some View {
        HStack(spacing: 8) {
            Text("Plant Name")
                .foregroundStyle(.white)

            TextField("", text: $name, prompt: Text("Pothos").foregroundStyle(.gray))
                .tint(Color.plantGreenBorder)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color(white: 0.18), in: Capsule())
    }

    // MARK: - Helpers
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0, content: content)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Color(white: 0.18), in: RoundedRectangle(cornerRadius: 24))
    }

    private func pickerRow<T: Identifiable & Hashable & CaseIterable>(
        _ title: String,
        icon: String,
        selection: Binding<T>,
        label: @escaping (T) -> String
    ) -> some View where T.AllCases: RandomAccessCollection {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(.white)

            Spacer()

            Picker(title, selection: selection) {
                ForEach(T.allCases) { option in
                    Text(label(option)).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(.gray)
        }
        .frame(height: 44)
    }

    // MARK: - Save
    private func save() {
        var plant = existing ?? Plant(name: "")
        plant.name = name.trimmingCharacters(in: .whitespaces)
        plant.room = room
        plant.light = light
        plant.wateringFrequency = frequency
        plant.waterAmount = amount
        onSave(plant)
        dismiss()
    }
}

#Preview {
    SetReminderView(plant: Plant(name: "Pothos"), onDelete: {})
}
