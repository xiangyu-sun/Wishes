import Vapor
import VaporMySQL
import Auth
import HTTP
let drop = Droplet()

drop.preparations += User.self

(drop.view as? LeafRenderer)?.stem.cache = nil

try drop.addProvider(VaporMySQL.Provider.self)


let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)


let basic = BasicController()
basic.addRoutes(drop: drop)

let users = UserController()
users.addRoutes(drop: drop)

let controller = WishesViewController()
controller.addRoutes(drop: drop)


drop.get { (request) -> ResponseRepresentable in
    return Response.init(redirect: "/wishes")
}

drop.run()
