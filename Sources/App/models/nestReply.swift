//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent

final class NestReply:Model,Content {
    static let schema: String = "nestReplys"
    
    @ID
    var id:UUID?
    
    @Field(key: "content")
    var content:String
    
    @Parent(key: "reply")
    var reply:Reply
    
    @Parent(key: "user")
    var user:User
    
    @Parent(key: "aimUser")
    var aimUser:User
    
    init() {
    }
    
    init(id:UUID? = nil,content:String,replyID:Reply.IDValue,userID:User.IDValue,aimUserID:User.IDValue) {
        self.content = content
        self.$reply.id = replyID
        self.$user.id = userID
        self.$aimUser.id = aimUserID
    }
}
