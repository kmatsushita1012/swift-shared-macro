// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(accessor) 
@attached(peer, names: arbitrary)
public macro Shared() = #externalMacro(module: "SharedMacroMacros", type: "SharedMacro")

public final class Shared<T> {
    public var wrappedValue: T
    
    public init(_ value: T) {
        self.wrappedValue = value
    }
}
