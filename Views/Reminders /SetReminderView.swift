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
    @State private var showDeleteAlert = false

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
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 8)

            Form {
                Section {
                    nameField
                }

                Section {
                    pickerRow("Room", icon: "location", selection: $room) { $0.displayName }
                    pickerRow("Light", icon: "sun.max", selection: $light) { $0.displayName }
                }

                Section {
                    pickerRow("Watering Days", icon: "drop", selection: $frequency) { $0.displayName }
                    pickerRow("Water", icon: "drop", selection: $amount) { $0.displayName }
                }

                if onDelete != nil {
                    Section {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("Delete Reminder")
                                .font(.subheadline)
                                .foregroundStyle(Color.deleteRed)
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .glassEffect(.regular.interactive(), in: .capsule)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 36)
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.sheetBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .presentationBackground(Color.sheetBackground)
        .alert("Delete Reminder", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete?()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this reminder?")
        }
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
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)

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
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(Color.plantGreen)
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
        .listRowBackground(Capsule().fill(Color.cardBackground))
    }

    // MARK: - Helpers
    private func pickerRow<T: Identifiable & Hashable & CaseIterable>(
        _ title: String,
        icon: String,
        selection: Binding<T>,
        label: @escaping (T) -> String
    ) -> some View where T.AllCases: RandomAccessCollection {
        Picker(selection: selection) {
            ForEach(T.allCases) { option in
                Text(label(option)).tag(option)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundStyle(.white)
        }
        .pickerStyle(.menu)
        .tint(.gray)
        .font(.subheadline)
        .frame(height: 40)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .listRowBackground(Color.cardBackground)
        // الفاصل يمتد بعرض الكرت كامل مثل السكتش
        .alignmentGuide(.listRowSeparatorLeading) { _ in -16 }
    }

    // MARK: - Save
    private func save() {
        // الزر يبقى أخضر مثل التصميم، بس ما يحفظ إذا الاسم فاضي
        guard canSave else { return }
        var plant = existing ?? Plant(name: "")
        plant.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        plant.room = room
        plant.light = light
        plant.wateringFrequency = frequency
        plant.waterAmount = amount
        onSave(plant)
        dismiss()
    }
}

#Preview {
    // نعرضها كـ sheet مثل ما تنفتح في التطبيق
    Color.black
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SetReminderView()
        }
}
