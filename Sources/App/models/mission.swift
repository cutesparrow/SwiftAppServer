//
//  File.swift
//  
//
//  Created by gaoyu shi on 14/12/20.
//
import Vapor
import Foundation
import Fluent


final class Mission:Model,Content {
    static let schema = "missions"
        
    @ID
    var id:UUID?
    
    @Field(key: "title")
    var title:String
    
    @Field(key: "type")
    var type:MissionType
    
    @Field(key: "date")
    var date:Date
    
    @Field(key:"price")
    var price:Int
    
    @Field(key: "status")
    var status:MissionStatus
    
    @Field(key: "content")
    var content:String
    
    @Parent(key: "user")
    var user:User
    
    @Siblings(through: MissionLanguage.self, from: \.$mission, to: \.$language)
    var missionLanguages:[Language]
    
    @Children(for: \.$mission)
    var missionFiles:[MissionFile]
    
    @Children(for: \.$mission)
    var missionBets:[Bet]
    
    @Children(for: \.$mission)
    var replys:[Reply]
    
    init() {
        
    }
    
    
    
    init(id:UUID? = nil,title:String,type:MissionType,date:Date,price:Int,status:MissionStatus,content:String,userID:User.IDValue) {
        self.title = title
        self.type = type
        self.date = date
        self.price = price
        self.status = status
        self.content = content
        self.$user.id = userID
    }
    
}

enum MissionType:String,Codable {
    static let name = "MISSION_TYPE"
    case assignment,toturial
}

enum MissionStatus:String,Codable {
    static let name = "MISSION_STATUS"
    case posted,betting,inprogress,submitted,finished
}
