//
//  WishesViewController.swift
//  Wishes
//
//  Created by alexander sun on 13/02/2017.
//
//

import Vapor
import HTTP

final class WishesViewController {
    
    func addRoutes(drop: Droplet) {
        let wishes = drop.grouped("wishes")
        wishes.get(handler: indexView)
        wishes.get("register", handler: registerView)
        wishes.post("register", handler: register)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        
        let user = try User.query().first()
        
        let parameters = try Node(node: [
            "authenticated": user != nil,
            "user": user?.makeNode()
            ])
        return try drop.view.make("index", parameters)
    }
    


    
    func registerView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }
    
    func register(request: Request) throws -> ResponseRepresentable {
        
        guard let email = request.formURLEncoded?["email"]?.string,
            let password = request.formURLEncoded?["password"]?.string,
            let name = request.formURLEncoded?["name"]?.string else {
                return "Missing email, password, or name"
        }
        _ = try User.register(name: name, email: email, rawPassword: password)
        return Response(redirect: "/users")
        
    }
    
    
    
    
    
    
    
}

