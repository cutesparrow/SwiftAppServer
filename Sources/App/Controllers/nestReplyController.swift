//
//  File.swift
//  
//
//  Created by gaoyu shi on 16/12/20.
//

import Foundation
import Fluent
import Vapor

struct NestReplyController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let nestReply = routes.grouped("public","nestReply")
        
        //post a nestreply url:/public/nestReply + jsonEncoded body
        let tokenProtected = nestReply.grouped(UserToken.authenticator())
        tokenProtected.post(use: postNestReply)
        
        //get one reply's nest reply list url:/public/nestReply?replyID=?
        nestReply.get(use: getReplyNestReplyList)
        
    }
    
    func postNestReply(req:Request) throws -> EventLoopFuture<NestReply> {
        let data = try req.content.decode(CreateNestReplyStruct.self)
        let userID = req.auth.get(User.self)?.id
        guard userID == data.userID else {
            throw Abort(.unauthorized)
        }
        let nestReply = NestReply(content: data.content, replyID: data.replyID, userID: data.userID, aimUserID: data.aimUserID)
        return nestReply.save(on: req.db).map{nestReply}
    }
    
    func getReplyNestReplyList(req:Request) throws -> EventLoopFuture<[NestReply]> {
        guard let replyID = req.query[UUID.self,at:"replyID"] else {
            throw Abort(.notFound)
        }
        return Reply.find(replyID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { reply in
                reply.$nestReplys.get(on: req.db)
            }
    }
}


struct CreateNestReplyStruct:Content {
    let content:String
    let replyID:UUID
    let userID:UUID
    let aimUserID:UUID
}
