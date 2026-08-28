import SwiftData
import SwiftUI

/// The app's landing screen, shown before the mode-picker. `onStartQuiz` is forwarded
/// straight through to `ModePickerView`, matching the callback it already expects.
struct HomeView: View {
    let onStartQuiz: (Set<GameMode>) -> Void

    @State private var showHowToPlay = false

    @Query private var highScores: [HighScoreRecord]
    @Query private var modeStats: [ModeStatRecord]

    private var bestScore: Int { highScores.first?.bestScore ?? 0 }
    private var strongestCategory: GameMode? { modeStats.strongestCategory() }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            HomeBackgroundArt()
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // Placeholder logo/title — plain styled text until a real logo exists.
                Text("GeoQuiz")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.accent)

                GlobeView()

                if bestScore > 0 {
                    VStack(spacing: 2) {
                        Text("Best score: \(bestScore) / \(QuizSession.maxPossibleRoundScore)")
                            .font(.subheadline.weight(.semibold))
                        if let strongestCategory {
                            Text("Your strongest category is \(strongestCategory.displayName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()

                VStack(spacing: 12) {
                    NavigationLink {
                        ModePickerView(onStart: onStartQuiz)
                    } label: {
                        Text("Play")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        showHowToPlay = true
                    } label: {
                        Text("How to Play")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showHowToPlay) {
            HowToPlayView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(onStartQuiz: { _ in })
    }
    .modelContainer(for: [HighScoreRecord.self, ModeStatRecord.self, AskedQuestionRecord.self], inMemory: true)
}
