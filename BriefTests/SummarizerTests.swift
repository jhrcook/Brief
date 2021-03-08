//
//  SummarizerTests.swift
//  BriefTests
//
//  Created by Joshua on 2/16/21.
//

@testable import Brief
import TextRank
import XCTest

class SummarizerTests: XCTestCase {
    var summarizer: Summarizer!
    var text: String!

    override func setUp() {
        super.setUp()
        summarizer = Summarizer()
        text = """
           Swifts are among the fastest of birds, and larger species like the white-throated needletail have been reported travelling at up to 169 km/h (105 mph) in level flight. Even the common swift can cruise at a maximum speed of 31 metres per second (112 km/h; 70 mph). In a single year the common swift can cover at least 200,000 km and in a lifetime, about two million kilometers; enough to fly to the Moon five times over. The wingtip bones of swiftlets are of proportionately greater length than those of most other birds. Changing the angle between the bones of the wingtips and forelimbs allows swifts to alter the shape and area of their wings to increase their efficiency and maneuverability at various speeds. They share with their relatives the hummingbirds a unique ability to rotate their wings from the base, allowing the wing to remain rigid and fully extended and derive power on both the upstroke and downstroke. The downstroke produces both lift and thrust, while the upstroke produces a negative thrust (drag) that is 60% of the thrust generated during the downstrokes, but simultaneously it contributes lift that is also 60% of what is produced during the downstroke. This flight arrangement might benefit the bird's control and maneuverability in the air. The swiftlets or cave swiftlets have developed a form of echolocation for navigating through dark cave systems where they roost. One species, the Three-toed swiftlet, has recently been found to use this navigation at night outside its cave roost too.
        """
    }

    override func tearDown() {
        summarizer = nil
        text = nil
        super.tearDown()
    }

    func testRunningPageRank() {
        // Given
        summarizer.inputText = text

        // When
        summarizer.summarize()

        // Then
        XCTAssertTrue(summarizer.textRankConverged!)
        XCTAssertTrue(summarizer.textRankIterations! > 2)
    }

    func testThatTheSummaryChangesWhenTheRatioDoes() {
        // Given
        summarizer.summaryRatio = 0.2
        summarizer.inputText = text

        // When
        summarizer.summarize()
        let originalSummary = summarizer.summarizedText
        summarizer.summaryRatio = 0.7
        let newSummary = summarizer.summarizedText

        // Then
        XCTAssertTrue(summarizer.textRankConverged!)
        XCTAssertTrue(originalSummary.count > newSummary.count)
    }

    func testPerformanceExample() throws {
        summarizer.inputText = text
        measure {
            summarizer.summarize()
        }
    }

    func testClearingBothInputAndOutput() {
        // Given
        summarizer.inputText = text
        summarizer.summarize()

        // When
        let oldInput = summarizer.inputText
        let oldOutput = summarizer.summarizedText
        summarizer.clear()

        // Then
        XCTAssertEqual(oldInput, text)
        XCTAssertTrue(!oldOutput.isEmpty)
        XCTAssertTrue(summarizer.inputText.isEmpty)
        XCTAssertTrue(summarizer.summarizedText.isEmpty)
    }

    func testClearingBothInputOnly() {
        // Given
        summarizer.inputText = text
        summarizer.summarize()

        // When
        let oldInput = summarizer.inputText
        let oldOutput = summarizer.summarizedText
        summarizer.clear(withUndoManager: nil, clearOutput: false)

        // Then
        XCTAssertEqual(oldInput, text)
        XCTAssertTrue(!oldOutput.isEmpty)
        XCTAssertTrue(summarizer.inputText.isEmpty)
        XCTAssertTrue(!summarizer.summarizedText.isEmpty)
    }
}
