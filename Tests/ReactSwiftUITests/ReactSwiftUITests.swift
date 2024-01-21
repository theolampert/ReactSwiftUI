import XCTest
@testable import ReactSwiftUI

final class RUITests: XCTestCase {
    func testCreateElement() throws {
        let result = createTree(
            source: """
                React.createElement(
                    'Button',
                    {
                        onClick: () => {
                            return true; // Just return something so we can assert on it.
                        }
                    },
                    'Hello, World!'
                );
            """
        )
        
        XCTAssertEqual(result?.type, .Button)
        XCTAssertEqual(result?.children?.first, .text("Hello, World!"))
        XCTAssertNotNil(result?.onClick)
        
        XCTAssertTrue(result!.onClick!.call(withArguments: []).toBool())
    }
}
