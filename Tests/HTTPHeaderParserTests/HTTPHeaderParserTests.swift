import XCTest
@testable import HTTPHeaderParser

final class HTTPHeaderParserTests: XCTestCase {
    static let singleLink = """
                <http://example.com/TheBook/chapter2>; rel=\"previous\";
                title=\"previous chapter\"
                """
    
    func testParseSingleLink() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(HTTPHeaderParserTests.singleLink)
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.singleLink)
        XCTAssertEqual(linkParams.count, 1, "")
        let firstLink = linkParams[0]
        XCTAssertEqual(firstLink.target, "http://example.com/TheBook/chapter2", "First link's target should parsed correctly")
        let firstLinkParams = firstLink.params
        XCTAssertEqual(firstLinkParams.rel, "previous", "First link's rel should parsed correctly")
        XCTAssertEqual(firstLinkParams.title, "previous chapter", "First link's title should parsed correctly")
        let lookupByRel = linkParams[rel: "previous"]
        XCTAssertNotNil(lookupByRel, "Should have a 'previous' rel")
        XCTAssertEqual(lookupByRel, firstLink, "Link fetched by rel should be equal to one fetched by index")
    }
    
    static let rootResourceRelation = """
                </>; rel="http://example.net/foo"
                """
    func testParseRootResourceRelation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.rootResourceRelation)
        XCTAssertEqual(linkParams.count, 1, "")
        XCTAssertEqual(linkParams[0].target, "/", "First link's target should parsed correctly")
        XCTAssertEqual(linkParams[0].params.rel, "http://example.net/foo")
    }
    
    static let multipleLinks = """
            </TheBook/chapter2>;
            rel="previous"; title*=UTF-8'de'letztes%20Kapitel,
            </TheBook/chapter4>;
            rel="next"; title*=UTF-8'de'n%c3%a4chstes%20Kapitel
            """
    func testParseMultipleLinks() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.multipleLinks)
        XCTAssertEqual(linkParams.count, 2, "")
        let firstLink = linkParams[0]
        XCTAssertEqual(firstLink.target, "/TheBook/chapter2", "First link's target should parsed correctly")
        XCTAssertEqual(firstLink.params.rel, "previous", "Second link's rel should parsed correctly")
        let secondLink = linkParams[1]
        XCTAssertEqual(secondLink.target, "/TheBook/chapter4", "Second link's target should parsed correctly")
        XCTAssertEqual(secondLink.params.rel, "next", "Second link's rel should parsed correctly")
        let lookupPrevious = linkParams[rel: "previous"]
        XCTAssertNotNil(lookupPrevious, "Should have a 'previous' rel")
        XCTAssertEqual(lookupPrevious, firstLink, "Link fetched by rel should be equal to one fetched by index")
        let lookupNext = linkParams[rel: "next"]
        XCTAssertNotNil(lookupNext, "Should have a 'next' rel")
        XCTAssertEqual(lookupNext, secondLink, "Link fetched by rel should be equal to one fetched by index")
    }
    
    static let sameTargetContext = """
                <http://example.org/>;
                 rel="start http://example.net/relation/other"
                """
    
    func testParseSameTargetContext() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.sameTargetContext)
        XCTAssertEqual(linkParams.count, 1, "")
        let firstLink = linkParams[0]
        XCTAssertEqual(firstLink.target, "http://example.org/", "First link's target should parsed correctly")
        XCTAssertEqual(firstLink.params.rel, "start http://example.net/relation/other", "Rel should match")
    }
    
    static let gitLabHeader = "<https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=1&per_page=3>; rel=\"prev\", <https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=3&per_page=3>; rel=\"next\", <https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=1&per_page=3>; rel=\"first\", <https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=3&per_page=3>; rel=\"last\""
    
    func testParseGitlabHeader() {
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.gitLabHeader)
        let prevLink = linkParams[0]
        let nextLink = linkParams[1]
        let firstLink = linkParams[2]
        let lastLink = linkParams[3]
        XCTAssertEqual(prevLink.target, "https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=1&per_page=3", "")
        XCTAssertEqual(prevLink.params.rel, "prev", "")
        XCTAssertEqual(nextLink.target, "https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=3&per_page=3", "")
        XCTAssertEqual(nextLink.params.rel, "next", "")
        XCTAssertEqual(firstLink.target, "https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=1&per_page=3", "")
        XCTAssertEqual(firstLink.params.rel, "first", "")
        XCTAssertEqual(lastLink.target, "https://gitlab.example.com/api/v4/projects/8/issues/8/notes?page=3&per_page=3", "")
        XCTAssertEqual(lastLink.params.rel, "last", "")
        XCTAssertEqual(linkParams[rel: "prev"]!, prevLink)
        XCTAssertEqual(linkParams[rel: "next"]!, nextLink)
        XCTAssertEqual(linkParams[rel: "first"]!, firstLink)
        XCTAssertEqual(linkParams[rel: "last"]!, lastLink)
    }
    
    static let relWithSemiColon = """
                <http://example.org/>;
                 rel="start http://example.net/relat;ion/other"
    """
    
    func testParseRelWithSemiColon() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let linkParams = HTTPHeaderParser.Link.parse(value: HTTPHeaderParserTests.relWithSemiColon)
        XCTAssertEqual(linkParams.count, 1, "")
        let firstLink = linkParams[0]
        XCTAssertEqual(firstLink.target, "http://example.org/", "First link's target should parsed correctly")
        XCTAssertEqual(firstLink.params.rel, "start http://example.net/relat;ion/other", "Rel should match")
    }

    static var allTests = [
        ("parseSingleLink", testParseSingleLink),
        ("parseRootResourceRelation", testParseRootResourceRelation),
        ("parseMultipleLinks", testParseMultipleLinks),
        ("parseSameTargetContext", testParseSameTargetContext),
        ("parseRelWithSemiColon", testParseRelWithSemiColon)
    ]
}
