//
//  File.swift
//  
//
//  Created by gaoyu shi on 14/12/20.
//

import Foundation
import Vapor
import Fluent



final class User: Model,Content {
    static let schema = "users"
    
    @ID   //PK
    var id:UUID?
    
    @Field(key: "account")
    var account:String
    
    @Field(key: "password")
    var password:String
    
    @Field(key:"sex")
    var sex:SexType
    
    @Field(key:"birthday")
    var birthday:Date
    
    @Field(key:"icon")
    var icon:String
    
    @Field(key: "email")
    var email:String
    
    @Children(for: \.$user)
    var missions:[Mission]
    
    @Children(for: \.$user)
    var bets:[Bet]
    
    @Siblings(through: WorkerLanguage.self, from: \.$user, to: \.$language)
    var userLanguages:[Language]
    
    
    @Children(for: \.$user)
    var replys:[Reply]
    
    @Children(for: \.$user)
    var nestReplys:[NestReply]
    
    @Children(for: \.$aimUser)
    var nestReplysForMe:[NestReply]
    
    @Children(for: \.$user)
    var tokens:[UserToken]
    
    init() {    }
    
    init(id:UUID? = nil,account:String,password:String,icon:String,sex:SexType,birthday:Date,email:String) {
        
        self.account = account
        self.password = password
        self.icon = icon
        self.sex = sex
        self.birthday = birthday
        self.email = email
    }
    
    final class Public:Content{
        var id:UUID?
        var account:String
        var sex:SexType
        var birthday:Date
        var icon:String
        var email:String
        init(id:UUID?,account:String,sex:SexType,birthday:Date,icon:String,email:String) {
            self.id = id
            self.account = account
            self.sex = sex
            self.birthday = birthday
            self.icon = icon
            self.email = email
        }

    }
    
}

extension User{
    func convertToPublic() -> User.Public {
        return User.Public(id: self.id, account: self.account, sex: self.sex, birthday: self.birthday, icon: self.icon, email: self.email)
    }
}


extension User{
    struct Create:Content {
        var account:String
        var sex:SexType
        var email:String
        var birthday:Date
        var password:String
        var confirmPassword: String
    }
}

extension User.Create:Validatable{
    static func validations(_ validations: inout Validations) {
        validations.add("account", as: String.self, is: !.empty)
        validations.add("email",as:String.self,is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}


extension User:ModelAuthenticatable{
    static let usernameKey: KeyPath<User, Field<String>> = \User.$account
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User{
    func generateToken() throws -> UserToken {
        try .init(value: [UInt8].random(count: 16).base64
                  , expiration: Date(timeIntervalSinceNow: 60 * 60 * 24), userID: self.requireID())
    }
}


enum SexType:String,Codable{
    static let name = "SEX_TYPE"
    case male,female
}



extension EventLoopFuture where Value:User{
    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user -> User.Public in
            user.convertToPublic()
        }
    }
}

