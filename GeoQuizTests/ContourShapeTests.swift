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
}
