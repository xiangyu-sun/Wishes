import Vapor
import Fluent
import Foundation

final class Wish {
    var id: Node?
    var name: String
    var link: String
    var userId: Node?
    
    
    var exists: Bool = false
    
    init(name: String, link: String, userId: Node? = nil) {
        self.id = UUID().uuidString.makeNode()
        self.name = name
        self.link = link
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        link = try node.extract("link")
        userId = try node.extract("userId")
    }
    

}

extension Wish:Model{
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "link": link,
            "userId": userId
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
