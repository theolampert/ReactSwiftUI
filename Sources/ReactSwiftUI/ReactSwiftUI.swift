import JavaScriptCore
import SwiftUI

let reactURL = Bundle.module.url(forResource: "react.development", withExtension: "js")!
let componentURL = Bundle.module.url(forResource: "component", withExtension: "js")!

let reactSrc = try! String(contentsOf: reactURL)
let componentSrc = try! String(contentsOf: componentURL)
let context: JSContext = JSContext()


enum ReactChild: Equatable, Hashable {
    case element(ReactElement)
    case text(String)
}

struct ReactElement: Equatable, Hashable {
    var type: String
    var props: [String: String]?
    var children: [ReactChild]?

    init(type: String, props: [String: String]? = nil, children: [ReactChild]? = nil) {
        self.type = type
        self.props = props
        self.children = children
    }
}

func createTree(source: String) -> ReactElement? {
    _ = context.evaluateScript(reactSrc)
    let component = context.evaluateScript(source)!
    return createTree(component: component)
}

func createTree(component: JSValue) -> ReactElement? {
    var children: [ReactChild] = []
    
    if let elementChildren = component.forProperty("props")?.forProperty("children") {
        print(elementChildren)
        if let text = elementChildren.toString() {
            children.append(.text(text))
        }
//        else if !elementChildren.isNull {
//            createTree(component: elementChildren)
//        }
    }
    
    return ReactElement(
        type: component.forProperty("type").toString(),
        children: children
    )
}
