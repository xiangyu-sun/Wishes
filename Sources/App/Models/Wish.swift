import Vapor
import Fluent
import Foundation

final class Wish {
    var id: Node?
    var name: Valid<NameValidator>
    var link: Valid<URLValidator>
    var userId: Node?
    
    public static var entity: String {
        return name + "es"
    }
    
    var exists: Bool = false
    
    init(name: String, link: String, userId: Node? = nil)throws {
        self.id = nil
        self.name = try name.validated()
        self.link = try link.validated()
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
        let linkString = try node.extract("link") as String
        link = try linkString.validated()
        userId = try node.extract("user_id")
    }
    

}

extension Wish:Model{
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "link": link.value,
            "user_id": userId
            ])
    }
}


extension Wish: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("wishes") { wishes in
            wishes.id()
            wishes.string("name")
            wishes.string("link")
            wishes.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("wishes")
    }
}
extension Wish {
    func user() throws -> User? {
        return try parent(userId, nil, User.self).get()
    }
}
