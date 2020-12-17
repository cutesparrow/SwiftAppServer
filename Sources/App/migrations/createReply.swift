//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent

struct CreateReply:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("replys")
            .id()
            .field("content",.string,.required)
            .field("mission",.uuid,.required,.references("missions", .id))
            .field("user",.uuid,.required,.references("users", .id))
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("replys").delete()
    }
}
