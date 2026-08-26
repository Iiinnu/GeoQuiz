import SwiftUI

/// Short explanation sheet presented from the home screen. Content only — no game state.
struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    section(
                        title: "Game Modes",
                        text: "Choose any mix of four modes to play: Capitals, Flags, Contours, and Satellite. Each round is 20 questions drawn from your selected modes."
                    )
                    section(
                        title: "Typed Answers",
                        text: "Type your answer instead of picking from a list — minor misspellings and typos are forgiven."
                    )
                    section(
                        title: "Hints",
                        text: "Not sure? Every mode offers a pre-answer hint — tap \"I don't know, give me a hint\" to reveal one before you guess."
                    )
                    section(
                        title: "Clues",
                        text: "Answer wrong and you're not out yet — you'll get a clue and one more chance to answer correctly before the question is scored as missed."
                    )
                    section(
                        title: "Satellite Images",
                        text: "Tap a satellite image to view it full-screen, where you can pinch to zoom in for a closer look."
                    )
                    section(
                        title: "Scoring",
                        text: "Each question is worth up to 3 points: 3 for a correct first try with no help, 2 if you used the hint, 1 if you needed a clue after answering wrong, and 0 if missed even after the clue. A full 20-question round is worth up to 60 points."
                    )
                }
                .padding()
            }
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func section(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HowToPlayView()
}
