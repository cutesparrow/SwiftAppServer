//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Fluent
import Vapor

final class MissionFile:Model,Content {
    static let schema: String = "missionFiles"
    
    @ID
    var id:UUID?
    
    @Field(key: "name")
    var name:String
    
    @Field(key:"path")
    var path:String
    
    @Parent(key: "mission")
    var mission:Mission
    
    init() {
        
    }
    
    init(id:UUID? = nil,name:String,path:String,missionID:Mission.IDValue) {
        self.name = name
        self.path = path
        self.$mission.id = missionID
    }
    
}
