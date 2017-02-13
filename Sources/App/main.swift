import Vapor
import VaporMySQL


let drop = Droplet()

drop.preparations += User.self

(drop.view as? LeafRenderer)?.stem.cache = nil

try drop.addProvider(VaporMySQL.Provider.self)

let basic = BasicController()
basic.addRoutes(drop: drop)

let users = UserController()
users.addRoutes(drop: drop)

let controller = WishesViewController()
controller.addRoutes(drop: drop)


drop.run()
