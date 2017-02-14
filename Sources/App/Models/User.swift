//
//  User.swift
//  Wishes
//
//  Created by alexander sun on 13/02/2017.
//
//
import Vapor
import Fluent
import Turnstile
import TurnstileCrypto
import Auth

final class User {
    
    var exists: Bool = false
    var id: Node?
    var name: Valid<NameValidator>
    var email: Valid<EmailValidator>
    var password: String
    
    init(name: String, email: String, rawPassword: String) throws {
        self.name = try name.validated()
        self.email = try email.validated()
        let validatedPassword: Valid<PasswordValidator> = try rawPassword.validated()
        self.password = BCrypt.hash(password: validatedPassword.value)
    }
    
    init(node: Node, in context: Context) throws {
        id = node["id"]
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
        let emailString = try node.extract("email") as String
        email = try emailString.validated()
        let passwordString = try node.extract("password") as String
        password = passwordString
    }
    

    static func register(name: String, email: String, rawPassword: String) throws -> User {
        var newUser = try User(name: name, email: email, rawPassword: rawPassword)
        if try User.query().filter("email", newUser.email.value).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
    }
    
}

extension User:Model{
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "email": email.value,
            "password": password,
            ])
    }
    
}

extension User:Preparation{
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("name")
            users.string("email")
            users.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

extension User: Auth.User {
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        let user: User?
        
        switch credentials {
        case let id as Identifier:
            user = try User.find(id.id)
        case let accessToken as AccessToken:
            user = try User.query().filter("access_token", accessToken.string).first()
        case let apiKey as APIKey:
            user = try User.query().filter("email", apiKey.id).filter("password", apiKey.secret).first()
        case let usernamePassword as UsernamePassword:
            
            user = try User.query().filter("email", usernamePassword.username).first()
            
            if let user = user{
                if !(try BCrypt.verify(password: usernamePassword.password, matchesHash: user.password)){
                    throw Abort.custom(status: .badRequest, message: "Credential is invalid.")
                }
            }
            
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not found.")
        }
        
        return u
    }
    
    static func register(credentials: Credentials) throws -> Auth.User {
        
        var user: User
        
        switch credentials {
            
        case let credential as UsernameEmailPassword:
            
            user = try User.register(name: credential.username, email: credential.email, rawPassword: credential.rawPassword)
            
        default:
            
            throw Abort.custom(status: .badRequest, message: "Unspported Register Method.")
        }
        
        return user
    }
}

extension User {
    func wishes() throws -> [Wish] {
        return try children(nil, Wish.self).all()
    }
}

