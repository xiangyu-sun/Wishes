//
//  CustomCredential.swift
//  Wishes
//
//  Created by alexander sun on 14/02/2017.
//
//
import Turnstile


public class UsernameEmailPassword: Credentials {
    /// Username    
    public let username: String
    
    /// Username
    public let email: String
    
    /// Password (unhashed)
    public let rawPassword: String
    
    /// Initializer for PasswordCredentials
    public init(username: String, rawPassword: String, email:String) {
        self.username = username
        self.rawPassword = rawPassword
        self.email = email
    }
}

