import SwiftUI

struct ResultsView: View {
    let session: QuizSession
    let onRestart: () -> Void

    private var missed: [QuestionResult] {
        session.results.filter { !$0.wasCorrect }
    }

    private var correctCount: Int {
        session.results.filter(\.wasCorrect).count
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(session.score) / \(session.maxScore)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                Text(summaryLine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 24)

            if missed.isEmpty {
                Spacer()
                Label("Perfect round!", systemImage: "star.fill")
                    .font(.headline)
                    .foregroundStyle(Theme.hint)
                Spacer()
            } else {
                List {
                    Section("Missed (\(missed.count))") {
                        ForEach(missed) { result in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(result.question.promptText)
                                    .font(.subheadline)
                                Text("Answer: \(result.question.primaryAnswer)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            Button(action: onRestart) {
                Text("Play Again")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private var summaryLine: String {
        let percent = session.totalCount == 0 ? 0 : Int((Double(correctCount) / Double(session.totalCount)) * 100)
        return "\(percent)% correct"
    }
}
