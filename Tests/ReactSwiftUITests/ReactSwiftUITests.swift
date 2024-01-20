import XCTest
@testable import ReactSwiftUI

final class RUITests: XCTestCase {
    func testCreateElement() throws {
        let result = createTree(
            source: """
                React.createElement(
                  'text',
                  null,
                  'Hello, World!'
                );
            """
        )
        
        XCTAssertEqual(result?.type, "text")
    }
}
