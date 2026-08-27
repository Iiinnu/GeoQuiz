import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var session: QuizSession?
    @State private var showResults = false
    @State private var isNewHighScore = false

    var body: some View {
        NavigationStack {
            HomeView { modes in
                let store = GameStatsStore(context: modelContext)
                let excluded = store.excludedCountryIDs(totalCountryCount: CountryData.all.count)
                let newSession = QuizSession(modes: modes, excludedCountryIDs: excluded)
                store.recordAsked(newSession.countryIDsByMode)
                session = newSession
                showResults = false
            }
            .navigationDestination(item: $session) { session in
                if showResults {
                    ResultsView(session: session, isNewHighScore: isNewHighScore, onRestart: restart)
                } else {
                    QuizView(session: session, onFinished: { finishRound(session) })
                }
            }
        }
        .tint(Theme.accent)
    }

    private func finishRound(_ session: QuizSession) {
        let store = GameStatsStore(context: modelContext)
        isNewHighScore = session.score > store.bestScore
        store.recordRoundResult(totalScore: session.score, perModePoints: session.perModePointsTally)
        showResults = true
    }

    private func restart() {
        session = nil
        showResults = false
        isNewHighScore = false
    }
}

extension QuizSession: Hashable {
    nonisolated static func == (lhs: QuizSession, rhs: QuizSession) -> Bool {
        lhs === rhs
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [HighScoreRecord.self, ModeStatRecord.self, AskedQuestionRecord.self], inMemory: true)
}
