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

                QuestionMediaView(question: question)

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

/// The visual for image-based modes. Flags renders a bundled 4:3 image; Aerial renders a
/// bundled square satellite crop (a fixed ~50km box around each capital, so every image
/// is genuinely square — a 4:3 frame would just letterbox it). Contours renders a vector
/// `ContourShape` looked up from `ContourData`. Capitals has no media, so this renders
/// nothing for it.
private struct QuestionMediaView: View {
    let question: Question

    var body: some View {
        switch question.mode {
        case .capitals:
            EmptyView()
        case .flags:
            if let assetName = question.country.flagAssetRef {
                Image(assetName)
                    .resizable()
                    .aspectRatio(4.0 / 3.0, contentMode: .fit)
                    .frame(maxWidth: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(cardBorder)
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            }
        case .aerial:
            if let assetName = question.country.aerialImageRef {
                VStack(spacing: 4) {
                    Image(assetName)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: 280, maxHeight: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(cardBorder)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

                    // Required by the Copernicus data terms wherever Sentinel data is
                    // displayed, not just in project docs — this is what an end user of
                    // the shipped app actually sees.
                    Text("Contains modified Copernicus Sentinel data")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        case .contours:
            ContourShape(rings: ContourData.all[question.country.borderShapeRef ?? ""] ?? [])
                .fill(.black, style: FillStyle(eoFill: true))
                .frame(maxWidth: 280, maxHeight: 280)
                .padding(16)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                .overlay(cardBorder)
        }
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 12).strokeBorder(.separator, lineWidth: 1)
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
