import SwiftUI

struct ResultsView: View {
    let session: QuizSession
    let onRestart: () -> Void

    private var missed: [QuestionResult] {
        session.results.filter { !$0.wasCorrect }
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(session.score) / \(session.totalCount)")
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
                    .foregroundStyle(.yellow)
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
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private var summaryLine: String {
        let percent = session.totalCount == 0 ? 0 : Int((Double(session.score) / Double(session.totalCount)) * 100)
        return "\(percent)% correct"
    }
}
