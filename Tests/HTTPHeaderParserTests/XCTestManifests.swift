import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LinkTests.allTests),
        testCase(RetryAfterTests.allTests),
        testCase(UriReferenceTests.allTests)
    ]
}
#endif
