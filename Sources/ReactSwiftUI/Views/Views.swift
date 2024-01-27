import SwiftUI

#Preview {
    VStack {
        ReactComponentView(
            component: """
            React.createElement('text', null, 'Hello, React!');
            """
        ).padding()
        
        ReactComponentView(
            component: """
            React.createElement('Button', null, [
                React.createElement('text', null, 'Press Me');
            ]);
            """
        ).padding()
    }
}
