import Vapor
import HTTP
import Fluent
import Auth

final class UserController {
    
    let protect = ProtectMiddleware(error:
        Abort.custom(status: .forbidden, message: "Not authorized.")
    )
    
    func addRoutes(drop: Droplet) {
        let users = drop.grouped("users")
        users.get(handler: index)
        users.post(handler: create)
        users.delete(User.self, handler: delete)
    
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: User.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        
        guard let json = request.json else { throw Abort.badRequest }
        
        var user =  try User(node: json)
        
        try user.save()
        
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    

    
}

