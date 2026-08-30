import XCTest
import SwiftUI
@testable import GeoQuiz

final class ContourShapeTests: XCTestCase {
    func testLetterboxesWideShapeWithinSquareRect() {
        // A 4:1 wide rectangle...
        let ring = [CGPoint(x: 0, y: 0), CGPoint(x: 4, y: 0), CGPoint(x: 4, y: 1), CGPoint(x: 0, y: 1)]
        let shape = ContourShape(rings: [ring])
        let bounds = shape.path(in: CGRect(x: 0, y: 0, width: 200, height: 200)).boundingRect

        // ...fit into a 200x200 square should stay 200 wide but far shorter than tall.
        XCTAssertEqual(bounds.width, 200, accuracy: 0.5)
        XCTAssertEqual(bounds.height, 50, accuracy: 0.5)
    }

    func testLetterboxesTallShapeWithinSquareRect() {
        // Mirror case: a tall, thin shape (like Chile) shouldn't get stretched wide.
        let ring = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 4), CGPoint(x: 0, y: 4)]
        let shape = ContourShape(rings: [ring])
        let bounds = shape.path(in: CGRect(x: 0, y: 0, width: 200, height: 200)).boundingRect

        XCTAssertEqual(bounds.height, 200, accuracy: 0.5)
        XCTAssertEqual(bounds.width, 50, accuracy: 0.5)
    }

    func testEmptyRingsProduceEmptyPath() {
        let shape = ContourShape(rings: [])
        let path = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertTrue(path.isEmpty)
    }

    func testMultipleRingsAreAllIncludedInBounds() {
        // Two disjoint squares, like separate islands, at opposite corners.
        let ringA = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)]
        let ringB = [CGPoint(x: 9, y: 9), CGPoint(x: 10, y: 9), CGPoint(x: 10, y: 10), CGPoint(x: 9, y: 10)]
        let shape = ContourShape(rings: [ringA, ringB])
        let bounds = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100)).boundingRect

        XCTAssertEqual(bounds.width, 100, accuracy: 0.5)
        XCTAssertEqual(bounds.height, 100, accuracy: 0.5)
    }

    // MARK: ContourFitTransform — shared letterbox math, and keeping target + neighbors aligned

    func testContourFitTransformReturnsNilForEmptyPoints() {
        XCTAssertNil(ContourFitTransform(points: [], in: CGRect(x: 0, y: 0, width: 100, height: 100)))
    }

    func testContourFitTransformKeepsTargetAndNeighborsAligned() {
        // A neighbor square sitting immediately to the right of the target square in
        // source space should still be touching it after a shared transform is applied
        // to both — proving target and neighbors aren't independently re-centered.
        let target = [[CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 0), CGPoint(x: 2, y: 2), CGPoint(x: 0, y: 2)]]
        let neighbor = [[CGPoint(x: 2, y: 0), CGPoint(x: 4, y: 0), CGPoint(x: 4, y: 2), CGPoint(x: 2, y: 2)]]
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)

        guard let transform = ContourFitTransform(points: (target + neighbor).flatMap { $0 }, in: rect) else {
            return XCTFail("expected a transform")
        }
        let targetBounds = transform.path(for: target).boundingRect
        let neighborBounds = transform.path(for: neighbor).boundingRect
        XCTAssertEqual(targetBounds.maxX, neighborBounds.minX, accuracy: 0.5)
    }

    func testContourFitTransformFitsTheCombinedBoundsNotJustTheTarget() {
        // A neighbor far to the right should widen the shared bounding box, so the
        // target ends up smaller within the rect than it would alone — this is what
        // gives the player spatial context instead of a maximized, context-free shape.
        let target = [[CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)]]
        let farNeighbor = [[CGPoint(x: 9, y: 0), CGPoint(x: 10, y: 0), CGPoint(x: 10, y: 1), CGPoint(x: 9, y: 1)]]
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

        let aloneTransform = ContourFitTransform(points: target.flatMap { $0 }, in: rect)!
        let combinedTransform = ContourFitTransform(points: (target + farNeighbor).flatMap { $0 }, in: rect)!

        let aloneWidth = aloneTransform.path(for: target).boundingRect.width
        let combinedWidth = combinedTransform.path(for: target).boundingRect.width
        XCTAssertLessThan(combinedWidth, aloneWidth)
    }
}
