//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent


struct CreateBet:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("bets")
            .id()
            .field("price",.int,.required)
            .field("status",.string,.required)
            .field("content",.string,.required)
            .field("mission",.uuid,.required,.references("missions", .id))
            .field("user",.uuid,.required,.references("users", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("bets").delete()
    }
}
