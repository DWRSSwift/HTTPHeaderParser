//
//  File.swift
//  
//
//  Created by David Stephens on 14/12/2020.
//

import XCTest
import HTTPHeaderParser

final class RetryAfterTests: XCTestCase {
    
    func testSecondsHeader() {
        let currentDate = Date()
        guard let header = HTTPHeaderParser.RetryAfter.parse(value: "5") else {
            XCTFail("Header should have been parseable")
            return
        }
        XCTAssertEqual(header.secondsTilRetry().rounded(), 5, "Should have parsed integer header correctly")
        let roundedRetryDate = header.retryDate.timeIntervalSince1970.rounded(.awayFromZero)
        let roundedOrignalDate = currentDate.addingTimeInterval(5).timeIntervalSince1970.rounded(.awayFromZero)
        XCTAssertEqual(roundedRetryDate, roundedOrignalDate, "Retry date parsed from header should be now + 5 seconds")
        XCTAssertFalse(header.canRetry(), "Should indicate retry not permitted")
    }
    
    func testFutureDate() {
        let date = Date().addingTimeInterval(120)
        guard let header = HTTPHeaderParser.RetryAfter.parse(value: Formatter.imfFixdate.string(from: date)) else {
            XCTFail("Header should have been parseable")
            return
        }
        XCTAssertNotNil(header, "Header should have been parseable")
        XCTAssertEqual(header.secondsTilRetry().rounded(.up), 120, "Should have parsed HTTP Date header correctly")
        XCTAssertFalse(header.canRetry(), "Should indicate retry not permitted")
    }
    
    func testPastDate() {
        let pastDateString = "Fri, 31 Dec 1999 23:59:59 GMT"
        let date = parseRfc7231DateString(pastDateString)
        guard let header = HTTPHeaderParser.RetryAfter.parse(value: pastDateString) else {
            XCTFail("Header should have been parseable")
            return
        }
        XCTAssertEqual(header.secondsTilRetry(), TimeInterval(0), "Date in the past should result in 0 seconds until retry")
        XCTAssertEqual(header.retryDate, date, "Parsed date should match header")
        XCTAssertTrue(header.canRetry(), "Should indicate retry permitted")
        
    }
    
    static var allTests = [
        ("testSecondsHeader", testSecondsHeader),
        ("testFutureDate", testFutureDate),
        ("testPastDate", testPastDate)
    ]
}
