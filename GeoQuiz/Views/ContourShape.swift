import SwiftUI

/// Letterbox-fit transform: maps a set of points' bounding box into a given rect,
/// preserving aspect ratio and centering. Shared by `ContourShape` (one country) and
/// `ContextualContourShape` (a country plus its neighbors, sharing one transform so they
/// stay geographically aligned).
struct ContourFitTransform {
    let minX: CGFloat
    let minY: CGFloat
    let scale: CGFloat
    let offsetX: CGFloat
    let offsetY: CGFloat

    init?(points: [CGPoint], in rect: CGRect) {
        guard let minX = points.map(\.x).min(),
              let maxX = points.map(\.x).max(),
              let minY = points.map(\.y).min(),
              let maxY = points.map(\.y).max(),
              maxX > minX, maxY > minY
        else {
            return nil
        }

        let width = maxX - minX
        let height = maxY - minY
        self.scale = min(rect.width / width, rect.height / height)
        self.minX = minX
        self.minY = minY
        self.offsetX = rect.minX + (rect.width - width * scale) / 2
        self.offsetY = rect.minY + (rect.height - height * scale) / 2
    }

    func apply(_ p: CGPoint) -> CGPoint {
        CGPoint(x: offsetX + (p.x - minX) * scale, y: offsetY + (p.y - minY) * scale)
    }

    /// Builds a closed path from a set of rings using this transform.
    func path(for rings: [[CGPoint]]) -> Path {
        var path = Path()
        for ring in rings where !ring.isEmpty {
            path.move(to: apply(ring[0]))
            for point in ring.dropFirst() {
                path.addLine(to: apply(point))
            }
            path.closeSubpath()
        }
        return path
    }
}

/// Renders a country's border outline as a filled silhouette, letterboxed to fit the
/// given rect while preserving the shape's true aspect ratio (a tall, thin country like
/// Chile shouldn't get stretched into a square). Must be filled with the even-odd rule
/// (`.fill(_:style: FillStyle(eoFill: true))`) — that single rule lets one flat list of
/// rings represent both disjoint landmasses (e.g. Indonesia's islands) and genuine holes
/// (e.g. San Marino inside Italy) with no extra bookkeeping to tell them apart.
struct ContourShape: Shape {
    let rings: [[CGPoint]]

    func path(in rect: CGRect) -> Path {
        guard let transform = ContourFitTransform(points: rings.flatMap { $0 }, in: rect) else {
            return Path()
        }
        return transform.path(for: rings)
    }
}

/// Renders a country's outline (solid fill) together with its real neighbors' outlines
/// (thin, unfilled, unlabeled) for spatial context. Neighbor rings live in the same
/// absolute coordinate space as the target (see `ContourData`), so a single shared
/// bounding box across target + neighbors is all that's needed to keep everything
/// geographically aligned — no per-country normalization. Falls back to showing just the
/// target when it has no neighbors we have contour data for (island nations, or real
/// neighbors outside our 79-country set).
struct ContextualContourShape: View {
    let targetRings: [[CGPoint]]
    let neighborRings: [[CGPoint]]

    var body: some View {
        GeometryReader { geo in
            let rect = CGRect(origin: .zero, size: geo.size)
            let allPoints = (targetRings + neighborRings).flatMap { $0 }

            if let transform = ContourFitTransform(points: allPoints, in: rect) {
                ZStack {
                    transform.path(for: neighborRings)
                        .stroke(Theme.accent.opacity(0.4), lineWidth: 1)
                    transform.path(for: targetRings)
                        .fill(Theme.accent, style: FillStyle(eoFill: true))
                }
            }
        }
    }
}
