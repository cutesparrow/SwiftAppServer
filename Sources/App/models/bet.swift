//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Fluent
import Vapor

final class Bet:Model,Content {
    static let schema: String = "bets"
    
    @ID
    var id:UUID?
    
    @Field(key:"price")
    var price:Int
    
    @Field(key: "status")
    var status:BetStatus
    
    @Field(key:"content")
    var content:String
    
    
    @Parent(key: "mission")
    var mission:Mission
    
    @Parent(key: "user")
    var user:User
    
    init() {
        
    }
    
    init(id:UUID? = nil,price:Int,status:BetStatus,content:String,missionID:Mission.IDValue,userID:User.IDValue) {
        self.price = price
        self.status = status
        self.content = content
        self.$mission.id = missionID
        self.$user.id = userID
    }
}



enum BetStatus:String,Codable {
    static let name = "BET_STATUS"
    case posted,chosen
}
