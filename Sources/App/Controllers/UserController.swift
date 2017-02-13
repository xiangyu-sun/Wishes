import Vapor
import HTTP
import Fluent

final class UserController {
    
    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("users")
        basic.get(handler: index)
        basic.post(handler: create)
        basic.delete(User.self, handler: delete)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: User.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    

    
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
