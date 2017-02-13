import Vapor
import HTTP
import VaporMySQL
import FluentMySQL

final class BasicController {
    
    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("basic")
        basic.get("version", handler: version)
    }
    
    func version(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? MySQLDriver {
            let version = try db.raw("SELECT @@version")
            return try JSON(node: version)
        } else {
            return "No db connection"
        }
    }
    
    
}
