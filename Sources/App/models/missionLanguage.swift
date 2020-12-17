//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//
import Vapor
import Fluent
import Foundation


final class MissionLanguage:Model,Content {
    static let schema: String = "missionLanguages"
    
    @ID
    var id:UUID?
    
    @Parent(key: "mission")
    var mission:Mission
    
    @Parent(key: "language")
    var language:Language
    
    init() {
        
    }
    
    init(id:UUID? = nil,missionID:Mission.IDValue,LanguageID:Language.IDValue) {
        self.$mission.id = missionID
        self.$language.id = LanguageID
    }
    
}
