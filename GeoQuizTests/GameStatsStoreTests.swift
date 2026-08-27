import SwiftData
import XCTest
@testable import GeoQuiz

@MainActor
final class GameStatsStoreTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: HighScoreRecord.self, ModeStatRecord.self, AskedQuestionRecord.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    func testBestScoreStartsAtZero() throws {
        let store = GameStatsStore(context: try makeContext())
        XCTAssertEqual(store.bestScore, 0)
    }

    func testRecordRoundResultOnlyRaisesHighScoreNeverLowersIt() throws {
        let store = GameStatsStore(context: try makeContext())

        store.recordRoundResult(totalScore: 45, perModePoints: [:])
        XCTAssertEqual(store.bestScore, 45)

        store.recordRoundResult(totalScore: 30, perModePoints: [:])
        XCTAssertEqual(store.bestScore, 45, "a lower score shouldn't overwrite the high score")

        store.recordRoundResult(totalScore: 51, perModePoints: [:])
        XCTAssertEqual(store.bestScore, 51)
    }

    func testExcludedCountryIDsReflectsWhatWasRecordedAsked() throws {
        let store = GameStatsStore(context: try makeContext())

        store.recordAsked([.capitals: ["US", "CA", "MX"]])
        let excluded = store.excludedCountryIDs(totalCountryCount: 10)

        XCTAssertEqual(excluded[.capitals], ["US", "CA", "MX"])
        XCTAssertEqual(excluded[.flags], [], "marking Capitals as asked shouldn't affect Flags' own pool")
    }

    func testExcludedCountryIDsResetsOnceEveryCountryInThatModeHasBeenAsked() throws {
        let store = GameStatsStore(context: try makeContext())

        store.recordAsked([.capitals: ["US", "CA", "MX"]])
        let excluded = store.excludedCountryIDs(totalCountryCount: 3)

        XCTAssertEqual(excluded[.capitals], [], "once every country in the pool has been asked, the cycle should reset")
    }

    func testRecordAskedIsIdempotentForAlreadyAskedCountries() throws {
        let store = GameStatsStore(context: try makeContext())

        store.recordAsked([.capitals: ["US"]])
        store.recordAsked([.capitals: ["US", "CA"]])
        let excluded = store.excludedCountryIDs(totalCountryCount: 10)

        XCTAssertEqual(excluded[.capitals], ["US", "CA"])
    }

    func testStrongestCategoryRequiresMinimumSampleSize() throws {
        let context = try makeContext()
        let store = GameStatsStore(context: context)

        // Higher average (3.0) but under the default minimum sample size of 10.
        store.recordRoundResult(totalScore: 0, perModePoints: [.capitals: (points: 27, count: 9)])
        // Lower average (2.0) but meets the minimum sample size.
        store.recordRoundResult(totalScore: 0, perModePoints: [.flags: (points: 20, count: 10)])

        let stats = try context.fetch(FetchDescriptor<ModeStatRecord>())
        XCTAssertEqual(
            stats.strongestCategory(), .flags,
            "Capitals has the higher average but hasn't cleared the minimum sample size yet"
        )
    }

    func testStrongestCategoryPicksTheHighestAverageOnceBothQualify() throws {
        let context = try makeContext()
        let store = GameStatsStore(context: context)

        store.recordRoundResult(totalScore: 0, perModePoints: [.capitals: (points: 30, count: 10)]) // avg 3.0
        store.recordRoundResult(totalScore: 0, perModePoints: [.flags: (points: 20, count: 10)]) // avg 2.0

        let stats = try context.fetch(FetchDescriptor<ModeStatRecord>())
        XCTAssertEqual(stats.strongestCategory(), .capitals)
    }
}
