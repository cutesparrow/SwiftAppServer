//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//


import Vapor
import Fluent
import Foundation

final class Language:Model,Content {
    static let schema: String = "languages"
    
    @ID
    var id:UUID?
    
    @Field(key: "name")
    var name:LanguageName
    
    @Siblings(through: MissionLanguage.self,from: \.$language, to: \.$mission)
    var languageMissions:[Mission]
    
    
    @Siblings(through: WorkerLanguage.self, from: \.$language, to:\.$user)
    var languageUsers:[User]
    
    
    
    
    
    init() {
        
    }
    
    init(id:UUID? = nil,name:LanguageName) {
        self.name = name
    }
}


enum LanguageName:String,Codable{
    static let name = "LANGUAGE_NAME"
    case python,swift,java,c
}
