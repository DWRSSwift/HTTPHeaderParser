//
//  File.swift
//  
//
//  Created by David Stephens on 24/10/2020.
//

import Foundation
import XCTest
@testable import HTTPHeaderParser

final class UriReferenceTests: XCTestCase {
    static let absoluteReference = "<http://example.com/TheBook/chapter2>;rel=after"
    
    func testAbsoluteUriReference() {
        let extractedUri = URIReference(from: Self.absoluteReference)
        XCTAssertNotNil(extractedUri)
        let value = extractedUri!.value
        XCTAssertEqual(value, "http://example.com/TheBook/chapter2")
        XCTAssertEqual(extractedUri!.remaining, ";rel=after")
    }
    
    static var allTests = [
        ("absoluteUriReference", testAbsoluteUriReference)
    ]
}
