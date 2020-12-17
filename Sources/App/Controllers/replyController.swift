//
//  File.swift
//  
//
//  Created by gaoyu shi on 16/12/20.
//

import Foundation
import Vapor
import Fluent

struct ReplyController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let reply = routes.grouped("public","reply")
        
        //post a reply to a mission url:/public/reply + jsonEncoded body
        let tokenProtected = reply.grouped(UserToken.authenticator())
        tokenProtected.post(use: postReply)
        
        //get one mission's reply list url:/public/reply?missionID=?
        reply.get(use: getMissionReplyList)
    }
    
    func postReply(req:Request) throws -> EventLoopFuture<Reply> {
        let data = try req.content.decode(CreateReplyStruct.self)
        let userID = req.auth.get(User.self)?.id
        guard userID == data.userID else {
            throw Abort(.unauthorized)
        }
        
        let reply = Reply(content: data.content, missionId: data.missionID, userId: data.userID)
        return reply.save(on: req.db).map{reply}
    }
    
    func getMissionReplyList(req:Request) throws-> EventLoopFuture<[Reply]> {
        guard let missionID = req.query[UUID.self,at:"missionID"] else {
           throw Abort(.notFound)
        }
        return Mission.find(missionID, on: req.db)
            .unwrap(or: Abort(.notFound))
                        .flatMap{mission in
                            mission.$replys.get(on:req.db)
                            
                        }
                        
    }
}


struct CreateReplyStruct:Content {
    let content:String
    let missionID:UUID
    let userID:UUID
    
}
