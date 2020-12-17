//
//  File.swift
//  
//
//  Created by gaoyu shi on 17/12/20.
//

import Foundation
import Vapor
import Fluent

final class UserToken: Model, Content {
    static let schema = "userTokens"
    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String
    
    @Field(key: "expiration")
    var expiration:Date
    
    @Parent(key: "user")
    var user: User
    
    

    init() {
        
    }
    init(id: UUID? = nil, value: String, expiration:Date,userID: User.IDValue) {
        self.id = id
        self.value = value
        self.expiration = expiration
        self.$user.id = userID
    }
}

extension UserToken:ModelTokenAuthenticatable{
    static var valueKey: KeyPath<UserToken, Field<String>> = \UserToken.$value
    static var userKey: KeyPath<UserToken, Parent<User>> = \UserToken.$user
    var isValid: Bool{
        true
    }
}
