//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent

final class Reply:Model,Content {
    static let schema: String = "replys"
    
    @ID
    var id:UUID?
    
    @Field(key: "content")
    var content:String
    
    @Parent(key: "mission")
    var mission:Mission
    
    @Parent(key: "user")
    var user:User
    
    @Children(for: \.$reply)
    var nestReplys:[NestReply]
    
    init() {
        
    }
    
    init(id:UUID? = nil, content:String, missionId:Mission.IDValue, userId:User.IDValue) {
        self.content = content
        self.$mission.id = missionId
        self.$user.id = userId
    }
}
