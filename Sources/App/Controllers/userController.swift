//
//  File.swift
//  
//
//  Created by gaoyu shi on 16/12/20.
//

import Foundation
import Vapor
import Fluent
import Crypto

struct UserController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let user = routes.grouped("personal","user")
        
        //register a user url: /personal/user/register + jsonEncoded body
        user.post("register", use: register)
        
        //log In url: /personal/user/login + jsonEncoded body
        let protect = user.grouped(User.authenticator())
        protect.post("login", use: logIn)
        
        //get user detail url:/personal/user/detail?userID=?
        user.get("detail", use: getUserDetail)
        
        //get self detail need token protected
        let tokenProtected = user.grouped(UserToken.authenticator())
        tokenProtected.get("me", use: getMe)
    }
    func getMe(req:Request) throws -> User{
        try req.auth.require(User.self)
        
    }
    
    func register(req:Request) throws -> EventLoopFuture<User.Public>{
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(account: create.account, password: Bcrypt.hash(create.password), icon: "", sex: create.sex, birthday: create.birthday, email: create.email)
        return user.save(on: req.db).map{user}.convertToPublic()
    }
    
    func logIn(req:Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map{ token }
    }
    
    func getUserDetail(req: Request) throws -> EventLoopFuture<User.Public> {
        
        
        guard let userID = req.query[UUID.self,at:"userID"] else {
            throw Abort(.notFound)
        }
        return User.find(userID, on: req.db)
            .unwrap(or: Abort(.notFound)).convertToPublic()
    }
    
}
