import SwiftUI

/// Flat 2D "spinning globe" illustration for the home screen. Continents are a
/// handful of overlapping blobs, not traced geography — this is a placeholder-grade
/// illustration, not a realistic 3D globe.
struct GlobeView: View {
    @State private var rotation: Double = 0

    private let size: CGFloat = 160

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.card)

            ZStack {
                meridian(widthFraction: 1.0)
                meridian(widthFraction: 0.55)
                continents
            }
            .rotationEffect(.degrees(rotation))
            .clipShape(Circle())

            Circle()
                .stroke(Theme.accent.opacity(0.5), lineWidth: 2)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 14).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .accessibilityHidden(true)
    }

    private var continents: some View {
        ZStack {
            blob(width: 70, height: 46).offset(x: -34, y: -40)
            blob(width: 46, height: 58).offset(x: 30, y: -6)
            blob(width: 58, height: 38).offset(x: -14, y: 42)
            blob(width: 34, height: 30).offset(x: 48, y: 50)
        }
    }

    private func blob(width: CGFloat, height: CGFloat) -> some View {
        Ellipse()
            .fill(Theme.accent.opacity(0.85))
            .frame(width: width, height: height)
    }

    private func meridian(widthFraction: CGFloat) -> some View {
        Ellipse()
            .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
            .frame(width: size * widthFraction, height: size)
    }
}

#Preview {
    GlobeView()
        .padding()
        .background(Theme.background)
}
