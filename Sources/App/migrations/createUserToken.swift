//
//  File.swift
//  
//
//  Created by gaoyu shi on 17/12/20.
//

import Foundation
import Fluent
import Vapor


struct CreateUserToken:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userTokens")
            .id()
            .field("value",.string,.required)
            .field("user",.uuid,.required)
            .field("expiration",.date,.required)
            .unique(on: "value")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userTokens").delete()
    }
}
