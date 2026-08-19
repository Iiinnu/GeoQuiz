import SwiftUI

struct ModePickerView: View {
    let onStart: (Set<GameMode>) -> Void

    @State private var selectedModes: Set<GameMode> = [.capitals]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Pick your modes")
                    .font(.title2.bold())
                    .padding(.top, 12)

                VStack(spacing: 12) {
                    ForEach(GameMode.allCases) { mode in
                        ModeCard(
                            mode: mode,
                            isSelected: selectedModes.contains(mode),
                            onToggle: { toggle(mode) }
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    onStart(selectedModes)
                } label: {
                    Text("Start Quiz (20 questions)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedModes.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("GeoQuiz")
        }
    }

    private func toggle(_ mode: GameMode) {
        guard mode.isImplemented else { return }
        if selectedModes.contains(mode) {
            selectedModes.remove(mode)
        } else {
            selectedModes.insert(mode)
        }
    }
}

private struct ModeCard: View {
    let mode: GameMode
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                Image(systemName: mode.systemImageName)
                    .font(.title2)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mode.displayName)
                        .font(.headline)
                    Text(mode.isImplemented ? mode.subtitle : "Coming soon")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            }
            .padding()
            .background(.quaternary.opacity(isSelected ? 0.6 : 0.25), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .opacity(mode.isImplemented ? 1 : 0.5)
        .disabled(!mode.isImplemented)
    }
}

#Preview {
    ModePickerView(onStart: { _ in })
}
