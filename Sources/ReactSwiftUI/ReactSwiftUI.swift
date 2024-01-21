import JavaScriptCore
import SwiftUI

let reactURL = Bundle.module.url(forResource: "react.development", withExtension: "js")!

let reactSrc = try! String(contentsOf: reactURL)
let context: JSContext = JSContext()

enum ElementTypes: String {
    case text
    case Button
}

enum ReactChild: Hashable {
    case element(ReactElement)
    case text(String)
}

struct ReactElement: Hashable {
    var type: ElementTypes
    var props: [String: String]?
    var children: [ReactChild]?
    
    var onClick: JSValue?

    init(
        type: ElementTypes,
        props: [String: String]? = nil,
        children: [ReactChild] = [],
        onClick: JSValue? = nil
    ) {
        self.type = type
        self.props = props
        self.children = children
        self.onClick = onClick
    }
}

func createTree(source: String) -> ReactElement? {
    _ = context.evaluateScript(reactSrc)
    let component = context.evaluateScript(source)!
    return createTree(component: component)
}

func createTree(component: JSValue) -> ReactElement? {
    
    var reactElement = ReactElement(
        type: ElementTypes(rawValue: component.forProperty("type").toString())!
    )
    
    if let onClick = component.forProperty("props")?.forProperty("onClick") {
        reactElement.onClick = onClick
    }
    
    if let elementChildren = component.forProperty("props")?.forProperty("children") {
        if let text = elementChildren.toString() {
            reactElement.children?.append(.text(text))
        }
    }
    
    return reactElement
}
