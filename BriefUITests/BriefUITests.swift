//
//  BriefUITests.swift
//  BriefUITests
//
//  Created by Joshua on 1/18/21.
//

import XCTest

class BriefUITests: XCTestCase {
    var app: XCUIApplication!
    var text: String!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()

        text = """
           Here is a sentence lion bear oh my. Tiger bear leopard shoe. Walrus cup half goat. Closet shoe goat bear.
        """

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testTapSummarizeButton() throws {
        // Clear text, type in new text, hit the summarize button.
        let swiftuiModifiedcontentBriefContentviewSwiftuiFlexframelayout1Appwindow1Window = XCUIApplication().windows["Brief"]
        swiftuiModifiedcontentBriefContentviewSwiftuiFlexframelayout1Appwindow1Window.buttons["Clear"].click()

        let textView = swiftuiModifiedcontentBriefContentviewSwiftuiFlexframelayout1Appwindow1Window.children(matching: .scrollView).element(boundBy: 0).children(matching: .textView).element
        textView.click()
        textView.typeText(text)
        swiftuiModifiedcontentBriefContentviewSwiftuiFlexframelayout1Appwindow1Window.buttons["Summarize"].click()

        // Test the output has been populated.
        XCTAssertGreaterThanOrEqual(
            swiftuiModifiedcontentBriefContentviewSwiftuiFlexframelayout1Appwindow1Window.staticTexts.count,
            2
        )
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
