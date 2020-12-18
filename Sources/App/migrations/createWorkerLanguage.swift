//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent

struct CreateWorkerLanguage:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("workerlanguages")
            .id()
            .field("user",.uuid,.required,.references("users", .id))
            .field("language",.uuid,.required,.references("languages", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("workerlanguages").delete()
    }
}
