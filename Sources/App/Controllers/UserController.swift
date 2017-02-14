import Vapor
import HTTP
import Fluent
import Auth

final class UserController {
    
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
    
    func wishesIndex(request: Request, user: User) throws -> ResponseRepresentable {
        let children = try user.wishes()
        return try JSON(node: children.makeNode())
    }
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return try user.makeJSON()
    }
}


extension UserController: ResourceRepresentable{
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            destroy: delete
        )
    }
}

