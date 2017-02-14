//
//  IndexViewController.swift
//  Wishes
//
//  Created by alexander sun on 13/02/2017.
//
//

import Vapor
import HTTP
import Auth
import Turnstile

final class IndexViewController {
    
    func addRoutes(drop: Droplet) {
        let wishes = drop.grouped("index")
        wishes.get(handler: indexView)
        wishes.get("register", handler: registerView)
        wishes.post("register", handler: register)
        wishes.get("login", handler: loginView)
        wishes.post("login", handler: login)
        wishes.get("logout", handler: logout)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        
        var user:User?
        
        do{
            user = try request.auth.user() as? User
        }
        catch _ as AuthError{
            
        }
      
        var wishes: [Wish]? = nil
        if let user = user {
            wishes = try user.wishes()
        }
        
  
        let parameters = try Node(node: [
            "wishes": wishes?.makeNode(),
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
    
    func loginView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        
        guard let email = request.formURLEncoded?["email"]?.string,
            let password = request.formURLEncoded?["password"]?.string
            else {
                return "Missing email, or password"
        }
        
        
        try request.auth.login(UsernamePassword(username: email, password: password))
        
        return Response(redirect: "/index")
        
    }
    
    
    
    func logout(request: Request) throws -> ResponseRepresentable {
        
        try request.auth.logout()
        
        return Response(redirect: "/index")
        
    }
    
}

