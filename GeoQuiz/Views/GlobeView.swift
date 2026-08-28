import SwiftUI

/// A thin-line wireframe globe — an outer circle, a static equator, and a few rotating
/// "meridian" ellipses that sweep across the face to suggest a slowly spinning sphere.
/// No fill, matching the linework style of `HomeBackgroundArt`.
struct GlobeView: View {
    @State private var rotation: Double = 0

    private let size: CGFloat = 320
    private let lineColor = Theme.accent

    var body: some View {
        ZStack {
            equator

            ZStack {
                meridian(widthFraction: 1.0)
                meridian(widthFraction: 0.62)
                meridian(widthFraction: 0.62).scaleEffect(x: -1, y: 1)
            }
            .rotationEffect(.degrees(rotation))
            .clipShape(Circle())

            Circle()
                .stroke(lineColor.opacity(0.75), lineWidth: 1.5)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .accessibilityHidden(true)
    }

    private var equator: some View {
        Ellipse()
            .stroke(lineColor.opacity(0.4), lineWidth: 1)
            .frame(width: size, height: size * 0.06)
    }

    private func meridian(widthFraction: CGFloat) -> some View {
        Ellipse()
            .stroke(lineColor.opacity(0.5), lineWidth: 1)
            .frame(width: size * widthFraction, height: size)
    }
}

#Preview {
    GlobeView()
        .padding()
        .background(Theme.background)
}
