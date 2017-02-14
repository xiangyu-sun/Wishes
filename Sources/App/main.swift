import Vapor
import VaporMySQL
import Auth
import HTTP
import Fluent

let drop = Droplet()

let models:[Preparation.Type] = [User.self, Wish.self]

drop.preparations.append(contentsOf: models)


(drop.view as? LeafRenderer)?.stem.cache = nil

try drop.addProvider(VaporMySQL.Provider.self)


let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)


let basic = BasicController()
basic.addRoutes(drop: drop)

let users = UserController()
users.addRoutes(drop: drop)

let controller = IndexViewController()
controller.addRoutes(drop: drop)


drop.get { (request) -> ResponseRepresentable in
    return Response.init(redirect: "/index")
}

drop.run()
