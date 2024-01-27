import JavaScriptCore
import SwiftUI

let reactURL = Bundle.module.url(forResource: "react.development", withExtension: "js")!

let reactSrc = try! String(contentsOf: reactURL)
let context: JSContext = JSContext()

enum ElementType: String {
    case text
    case Button
}

enum ReactChild: Hashable {
    case element(ReactElement)
    case text(String)
}

struct ReactElement: Hashable {
    var type: ElementType
    var props: [String: String]?
    var children: [ReactChild]?
    
    var onClick: JSValue?

    init(
        type: ElementType,
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

func createTree(from source: String) -> ReactElement? {
    context.evaluateScript(reactSrc)
    guard let component = context.evaluateScript(source) else {
        return nil
    }
    return createTree(component: component)
}

func parse(item: Any) -> ReactChild? {
    if let dict = item as? [String: Any], let typeString = dict["type"] as? String, let type = ElementType(rawValue: typeString) {
        if let props = dict["props"] as? [String: Any] {
            var children: [ReactChild] = []
            if let childList = props["children"] as? [Any] {
                children = childList.compactMap { parse(item: $0) }
                return ReactChild.element(ReactElement(type: type, children: children))
            } else if let text = props["children"] as? String {
                let textElement = ReactChild.text(text)
                return textElement
            }
        }
    }
    
    return nil
}

func parse(list: [Any]) -> [ReactChild] {
    return list.compactMap { parse(item: $0) }
}


func createTree(component: JSValue) -> ReactElement? {
    guard let elementType = ElementType(rawValue: component.forProperty("type").toString()) else {
        return nil
    }

    var reactElement = ReactElement(type: elementType)

    if let onClick = component.forProperty("props")?.forProperty("onClick") {
        reactElement.onClick = onClick
    }

    if let elementChildren = component.forProperty("props")?.forProperty("children") {
        if let components = elementChildren.toArray() {
            reactElement.children = parse(list: components)
        } else if let text = elementChildren.toString() {
            reactElement.children = [.text(text)]
        }
    }

    return reactElement
}
