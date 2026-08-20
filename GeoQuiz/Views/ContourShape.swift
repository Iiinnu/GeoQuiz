import SwiftUI

/// Renders a country's border outline as a filled silhouette, letterboxed to fit the
/// given rect while preserving the shape's true aspect ratio (a tall, thin country like
/// Chile shouldn't get stretched into a square). Must be filled with the even-odd rule
/// (`.fill(_:style: FillStyle(eoFill: true))`) — that single rule lets one flat list of
/// rings represent both disjoint landmasses (e.g. Indonesia's islands) and genuine holes
/// (e.g. San Marino inside Italy) with no extra bookkeeping to tell them apart.
struct ContourShape: Shape {
    let rings: [[CGPoint]]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let allPoints = rings.flatMap { $0 }
        guard let minX = allPoints.map(\.x).min(),
              let maxX = allPoints.map(\.x).max(),
              let minY = allPoints.map(\.y).min(),
              let maxY = allPoints.map(\.y).max(),
              maxX > minX, maxY > minY
        else {
            return path
        }

        let width = maxX - minX
        let height = maxY - minY
        let scale = min(rect.width / width, rect.height / height)
        let offsetX = rect.minX + (rect.width - width * scale) / 2
        let offsetY = rect.minY + (rect.height - height * scale) / 2

        func transform(_ p: CGPoint) -> CGPoint {
            CGPoint(x: offsetX + (p.x - minX) * scale, y: offsetY + (p.y - minY) * scale)
        }

        for ring in rings where !ring.isEmpty {
            path.move(to: transform(ring[0]))
            for point in ring.dropFirst() {
                path.addLine(to: transform(point))
            }
            path.closeSubpath()
        }
        return path
    }
}
