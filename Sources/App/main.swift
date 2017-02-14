import Vapor
import VaporMySQL
import Auth
import HTTP
import Fluent

let drop = Droplet()

let models:[Preparation.Type] = [User.self, Wish.self]


try drop.addProvider(VaporMySQL.Provider.self)

drop.preparations += User.self
drop.preparations += Wish.self


(drop.view as? LeafRenderer)?.stem.cache = nil



let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)


let basic = BasicController()
basic.addRoutes(drop: drop)

let users = UserController()
drop.resource("users", users)

let controller = IndexViewController()
controller.addRoutes(drop: drop)


let wishes = WishesController()
drop.resource("wishes", wishes)

drop.get { (request) -> ResponseRepresentable in
    return Response.init(redirect: "/index")
}

drop.run()
