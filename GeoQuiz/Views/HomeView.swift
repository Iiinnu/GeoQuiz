import SwiftUI

/// The app's landing screen, shown before the mode-picker. `onStartQuiz` is forwarded
/// straight through to `ModePickerView`, matching the callback it already expects.
struct HomeView: View {
    let onStartQuiz: (Set<GameMode>) -> Void

    @State private var showHowToPlay = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Placeholder logo/title — plain styled text until a real logo exists.
            Text("GeoQuiz")
                .font(.system(size: 48, weight: .bold, design: .rounded))

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
        .sheet(isPresented: $showHowToPlay) {
            HowToPlayView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(onStartQuiz: { _ in })
    }
}
