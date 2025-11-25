import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SharedMacro: PeerMacro, AccessorMacro {
    public static func expansion(
            of attribute: AttributeSyntax,
            providingAccessorsOf declaration: some DeclSyntaxProtocol,
            in context: some MacroExpansionContext
        ) throws -> [AccessorDeclSyntax] {

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
              let _ = binding.typeAnnotation?.type
        else { return [] }

        let name = identifier.identifier.text
        let boxName = "$\(name)"

        let accessorDecl = """
        get { \(boxName).wrappedValue }
        set {
            \(boxName).wrappedValue = newValue
        }
        """
        return [AccessorDeclSyntax(stringLiteral: accessorDecl)]
    }

    public static func expansion(
        of attribute: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
              let type = binding.typeAnnotation?.type
        else { return [] }

        let name = identifier.identifier.text
        let boxName = "$\(name)"

        let peerDecl = """
        private(set) var \(boxName): Shared<\(type.description)>
        """
        return [DeclSyntax(stringLiteral: peerDecl)]
    }
}



@main
struct SharedMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SharedMacro.self
    ]
}
