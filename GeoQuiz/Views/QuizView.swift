import SwiftUI

struct QuizView: View {
    @ObservedObject var session: QuizSession
    let onFinished: () -> Void

    @State private var inputText = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            if let question = session.currentQuestion {
                Spacer(minLength: 0)

                Text(question.promptText)
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                if case .awaitingRetry(let clue) = session.state {
                    ClueBanner(text: clue)
                }

                if case .correct = session.state {
                    FeedbackBanner(isCorrect: true, answer: question.primaryAnswer)
                }
                if case .missed = session.state {
                    FeedbackBanner(isCorrect: false, answer: question.primaryAnswer)
                }

                Spacer(minLength: 0)

                answerControl(for: question)
            }
        }
        .padding()
        .navigationTitle("Question \(min(session.currentIndex + 1, session.totalCount)) of \(session.totalCount)")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: session.currentIndex) { _, _ in
            inputText = ""
            inputFocused = true
        }
    }

    private var header: some View {
        HStack {
            Text("Score: \(session.score)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            ProgressView(value: Double(session.currentIndex), total: Double(session.totalCount))
                .frame(width: 120)
        }
    }

    @ViewBuilder
    private func answerControl(for question: Question) -> some View {
        switch session.state {
        case .answering, .awaitingRetry:
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    TextField("Your answer", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .focused($inputFocused)
                        .onSubmit(submit)

                    Button("Submit", action: submit)
                        .buttonStyle(.borderedProminent)
                        .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                if session.state == .answering {
                    Button(action: { session.requestHint() }) {
                        Label("I don't know, give me a hint", systemImage: "lightbulb")
                            .font(.subheadline)
                    }
                    .buttonStyle(.borderless)
                }
            }
        case .correct, .missed:
            Button(action: next) {
                Text(session.currentIndex + 1 >= session.totalCount ? "See Results" : "Next Question")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func submit() {
        session.submit(inputText)
        inputText = ""
    }

    private func next() {
        session.advance()
        if session.isFinished {
            onFinished()
        }
    }
}

private struct ClueBanner: View {
    let text: String
    var body: some View {
        Label(text, systemImage: "lightbulb")
            .font(.subheadline)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.yellow.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct FeedbackBanner: View {
    let isCorrect: Bool
    let answer: String
    var body: some View {
        Label(
            isCorrect ? "Correct!" : "Missed it — answer: \(answer)",
            systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
        )
        .font(.subheadline.weight(.semibold))
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(isCorrect ? .green : .red)
        .background((isCorrect ? Color.green : Color.red).opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
    }
}
