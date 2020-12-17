//
//  File.swift
//  
//
//  Created by gaoyu shi on 16/12/20.
//

import Foundation
import Vapor
import Fluent

struct BetController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bet = routes.grouped("public","bet")
        
        //get bet list by userID url:/public/bet/user?userID=?
        bet.get("user", use: getUserBetList)
        
        //get detail of a bet url:/public/bet/detail?betID=?
        bet.get("detail", use: getBetDetail)
        
        //post a bet url:/public/bet/detail + jsonEncoded body
        let tokenProtected = bet.grouped(UserToken.authenticator())
        tokenProtected.post("detail", use: postBetDetail)
        
        //get one mission's bet list url:/public/bet/mission?missionID=?
        bet.get("mission", use: getMissionBetList)
    }
    
    func getUserBetList(req:Request) throws -> EventLoopFuture<[Bet]>{
        guard let userID = req.query[UUID.self,at:"userID"] else {
            throw Abort(.notFound)
        }
        return User.find(userID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$bets.get(on: req.db)
            }
    }
    
    func getBetDetail(req:Request) throws -> EventLoopFuture<Bet>{
        guard let betID = req.query[UUID.self,at:"betID"] else {
            throw Abort(.notFound)
        }
        return Bet.find(betID, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func postBetDetail(req:Request) throws -> EventLoopFuture<Bet> {
        let data = try req.content.decode(CreateBetStruct.self)
        let userId = req.auth.get(User.self)?.id
        guard userId == data.userID else {
            throw Abort(.unauthorized)
        }
        let bet = Bet(price: data.price, status: data.status, content: data.content, missionID: data.missionID, userID: data.userID)
        return bet.save(on:req.db).map{ bet }
    }
    
    func getMissionBetList(req: Request) throws -> EventLoopFuture<[Bet]> {
        guard let missionID = req.query[UUID.self,at:"missionID"] else {
            throw Abort(.notFound)
        }
        return Mission.find(missionID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { mission in
                mission.$missionBets.get(on: req.db)
            }
    }
    
}


struct CreateBetStruct:Content {
    let price:Int
    let status:BetStatus
    let content:String
    let missionID:UUID
    let userID:UUID
}
