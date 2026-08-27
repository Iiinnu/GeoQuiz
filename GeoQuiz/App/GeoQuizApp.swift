import SwiftUI

@main
struct GeoQuizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [HighScoreRecord.self, ModeStatRecord.self, AskedQuestionRecord.self])
    }
}
