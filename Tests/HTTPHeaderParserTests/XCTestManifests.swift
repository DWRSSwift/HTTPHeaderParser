import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HTTPHeaderParserTests.allTests),
        testCase(UriReferenceTests.allTests)
    ]
}
#endif
