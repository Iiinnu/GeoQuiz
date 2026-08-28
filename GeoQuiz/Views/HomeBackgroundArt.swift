import SwiftUI

/// Decorative, abstract background for the home screen — layered wavy line clusters,
/// scattered dots, and a dashed accent arc, all in muted green tones. Built as small,
/// independent `Shape`s rather than one flat image so individual elements (a cluster's
/// curve, a dot's placement) can be tweaked without regenerating any asset. Everything
/// here is purely decorative — never announced to accessibility clients.
struct HomeBackgroundArt: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Upper-left ribbon cluster.
                RibbonWaves(lineCount: 5, amplitude: 10, waveLength: 1.4, phase: 0.3)
                    .stroke(Theme.accent.opacity(0.28), lineWidth: 1.2)
                    .frame(width: w * 0.62, height: h * 0.16)
                    .position(x: w * 0.16, y: h * 0.10)

                // Upper-right ribbon cluster, a softer tone for depth.
                RibbonWaves(lineCount: 4, amplitude: 9, waveLength: 1.1, phase: 1.4)
                    .stroke(Theme.accentSoft.opacity(0.30), lineWidth: 1.2)
                    .frame(width: w * 0.58, height: h * 0.14)
                    .position(x: w * 0.86, y: h * 0.16)

                // Lower-left ribbon cluster.
                RibbonWaves(lineCount: 4, amplitude: 11, waveLength: 1.2, phase: 2.1)
                    .stroke(Theme.accentSoft.opacity(0.30), lineWidth: 1.2)
                    .frame(width: w * 0.6, height: h * 0.15)
                    .position(x: w * 0.14, y: h * 0.90)

                // Lower-right ribbon cluster.
                RibbonWaves(lineCount: 5, amplitude: 10, waveLength: 1.5, phase: 0.8)
                    .stroke(Theme.accent.opacity(0.26), lineWidth: 1.2)
                    .frame(width: w * 0.64, height: h * 0.17)
                    .position(x: w * 0.84, y: h * 0.94)

                // Thin dashed accent arc, upper-right quadrant.
                DashedArc(startAngle: .degrees(160), endAngle: .degrees(330))
                    .stroke(Theme.accent.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [3, 6]))
                    .frame(width: w * 0.5, height: w * 0.5)
                    .position(x: w * 0.9, y: h * 0.32)

                ScatteredDots(seed: 7)
                    .frame(width: w, height: h)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A handful of parallel, gently wavy lines — the "layered ribbon" look. Deterministic
/// (no randomness), so it renders identically every time.
private struct RibbonWaves: Shape {
    let lineCount: Int
    let amplitude: CGFloat
    let waveLength: CGFloat
    let phase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard lineCount > 0 else { return path }
        let spacing = rect.height / CGFloat(lineCount + 1)
        let steps = 48

        for i in 0..<lineCount {
            let baseY = rect.minY + spacing * CGFloat(i + 1)
            var line = Path()
            for step in 0...steps {
                let t = CGFloat(step) / CGFloat(steps)
                let x = rect.minX + rect.width * t
                let wave = sin(t * .pi * 2 / waveLength + phase + CGFloat(i) * 0.5) * amplitude
                let point = CGPoint(x: x, y: baseY + wave)
                if step == 0 {
                    line.move(to: point)
                } else {
                    line.addLine(to: point)
                }
            }
            path.addPath(line)
        }
        return path
    }
}

/// One dashed arc, used as a single decorative accent line.
private struct DashedArc: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: min(rect.width, rect.height) / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

/// Small dots scattered mostly toward the left/right edges, leaving the vertical center
/// band (where the logo and buttons sit) calm and low-detail. Positions/sizes/opacities
/// are generated once from a fixed seed — deterministic, not re-randomized per redraw.
private struct ScatteredDots: View {
    let seed: Int

    private struct Dot: Identifiable {
        let id: Int
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
        let soft: Bool
    }

    private var dots: [Dot] {
        (0..<42).map { i in
            let bandRoll = Self.pseudoRandom(seed * 1000 + i)
            let x: CGFloat
            if bandRoll < 0.46 {
                x = 0.02 + Self.pseudoRandom(seed * 2000 + i) * 0.26
            } else if bandRoll < 0.92 {
                x = 0.72 + Self.pseudoRandom(seed * 3000 + i) * 0.26
            } else {
                // A few faint stragglers drifting toward the calm center band.
                x = 0.30 + Self.pseudoRandom(seed * 4000 + i) * 0.40
            }
            let y = Self.pseudoRandom(seed * 5000 + i)
            let size = 3 + Self.pseudoRandom(seed * 6000 + i) * 9
            let baseOpacity = bandRoll >= 0.92 ? 0.10 : 0.14 + Self.pseudoRandom(seed * 7000 + i) * 0.22
            return Dot(id: i, x: x, y: y, size: size, opacity: baseOpacity, soft: i % 2 == 0)
        }
    }

    /// Sine-hash trick for a stable, seed-based pseudo-random value in [0, 1).
    private static func pseudoRandom(_ seed: Int) -> CGFloat {
        let x = sin(Double(seed) * 12.9898) * 43758.5453
        return CGFloat(x - floor(x))
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(dots) { dot in
                Circle()
                    .fill((dot.soft ? Theme.accentSoft : Theme.accent).opacity(dot.opacity))
                    .frame(width: dot.size, height: dot.size)
                    .position(x: dot.x * geo.size.width, y: dot.y * geo.size.height)
            }
        }
    }
}

#Preview {
    HomeBackgroundArt()
        .background(Theme.background)
}
