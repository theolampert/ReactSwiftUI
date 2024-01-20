import SwiftUI

struct ReactComponentView: View {
    init(component: String) {
        self.component = component
        self.reactElement = createTree(source: component)!
    }
    
    let component: String
    let reactElement: ReactElement
    
    @ViewBuilder
    func renderChildren(child: ReactChild?) -> some View {
        if let child = child {
            switch child {
            case .text(let text):
                Text(text)
            case .element(_):
                EmptyView()
            }
        }
        
    }
    
    var body: some View {
        Group {
            if reactElement.type == "text" {
                ForEach(reactElement.children!, id: \.self) { child in
                    renderChildren(child: child)
                }
            }
        }
    }
}

#Preview {
    ReactComponentView(
        component: """
        React.createElement('text', null, 'Hello, React!');
        """
    ).padding()
}
