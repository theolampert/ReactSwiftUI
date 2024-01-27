import XCTest
@testable import ReactSwiftUI

final class RUITests: XCTestCase {
    func testCreateElement() throws {
        let result = createTree(
            from: """
                React.createElement(
                    'Button',
                    {
                        onClick: () => {
                            return true; // Just return something so we can assert on it.
                        }
                    },
                    [
                        React.createElement(
                            'text', null, 'Press'
                        )
                    ]
                );
            """
        )!
        
        XCTAssertEqual(result.type, .Button)
        XCTAssertEqual(result.children![0], .text("Press"))
        XCTAssertNotNil(result.onClick)
        
        XCTAssertTrue(result.onClick!.call(withArguments: []).toBool())
    }
}
