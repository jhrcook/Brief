//
//  PasteboardManagerTests.swift
//  BriefTests
//
//  Created by Joshua on 2/21/21.
//

@testable import Brief
import XCTest

class PasteboardManagerTests: XCTestCase {
    var pasteboardManager: PasteboardManager!
    var currentCopiedText: String!

    override func setUpWithError() throws {
        try super.setUpWithError()
        pasteboardManager = PasteboardManager()
        currentCopiedText = pasteboardManager.getCurrentlyCopiedText()
    }

    override func tearDownWithError() throws {
        pasteboardManager.copyToClipboard(currentCopiedText)
        pasteboardManager = nil
        currentCopiedText = nil
        try super.tearDownWithError()
    }

    func testCopyingSummaryToPasteboard() {
        // Given
        let text = "Here is some goood text for copying to pasteboard during a test 👌🏼"

        // When
        pasteboardManager.copyToClipboard(text)

        // Then
        XCTAssertEqual(text, pasteboardManager.getCurrentlyCopiedText()!)
    }

    func testNilStringDoesNotGetCopied() {
        // Given
        let nonNilString = "Here is some text."
        pasteboardManager.copyToClipboard(nonNilString)
        let firstCopy = pasteboardManager.getCurrentlyCopiedText()

        // When
        pasteboardManager.copyToClipboard(nil)
        let secondCopy = pasteboardManager.getCurrentlyCopiedText()

        // Then
        XCTAssertEqual(firstCopy, secondCopy)
    }
}
