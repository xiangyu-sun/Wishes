//
//  EmailUsernamePassword.swift
//  Wishes
//
//  Created by alexander sun on 13/02/2017.
//
//
import Auth

public class UsernamePassword: Credentials {
    /// Username or email address
    public let username: String
    
    /// Password (unhashed)
    public let password: String
    
    /// Initializer for PasswordCredentials
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

