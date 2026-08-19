import SwiftUI

struct ContentView: View {
    @State private var session: QuizSession?
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            ModePickerView { modes in
                let newSession = QuizSession(modes: modes)
                session = newSession
                showResults = false
            }
            .navigationDestination(item: $session) { session in
                if showResults {
                    ResultsView(session: session, onRestart: restart)
                } else {
                    QuizView(session: session, onFinished: { showResults = true })
                }
            }
        }
    }

    private func restart() {
        session = nil
        showResults = false
    }
}

extension QuizSession: Identifiable {
    nonisolated var id: ObjectIdentifier { ObjectIdentifier(self) }
}

#Preview {
    ContentView()
}
