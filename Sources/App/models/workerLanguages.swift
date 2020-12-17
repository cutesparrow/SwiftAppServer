//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Fluent
import Vapor

final class WorkerLanguage:Model,Content {
    static let schema: String = "workerlanguages"
    
    @ID
    var id:UUID?
    
    @Parent(key: "user")
    var user:User
    
    @Parent(key: "language")
    var language:Language
    
    init() {
        
    }
    
    init(id:UUID? = nil, userID:User.IDValue,languageID:Language.IDValue) {
        self.$user.id = userID
        self.$language.id = languageID
    }
}
