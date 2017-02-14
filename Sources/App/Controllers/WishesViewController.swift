import Vapor
import HTTP

final class WishesController {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Wish.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        
        guard let json = request.json else { throw Abort.badRequest }
        
        var wish = try Wish(node: json)
        
        try wish.save()
        
        return wish
    }
    
    func show(request: Request, wish: Wish) throws -> ResponseRepresentable {
        return wish
    }
    
    func update(request: Request, wish: Wish) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        
        let new = try Wish(node: json)
        
        var wish = wish
        
        wish.name = new.name
        
        wish.link = new.link
        
        try wish.save()
        
        return wish
    }
    
    func delete(request: Request, wish: Wish) throws -> ResponseRepresentable {
        try wish.delete()
        return JSON([:])
    }
    
    
}

extension WishesController:ResourceRepresentable{
    func makeResource() -> Resource<Wish> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}


