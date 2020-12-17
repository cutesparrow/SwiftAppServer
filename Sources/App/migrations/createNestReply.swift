//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//

import Foundation
import Vapor
import Fluent

struct CreateNestReply:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("nestReplys")
            .id()
            .field("content",.string,.required)
            .field("reply",.uuid,.required,.references("replys", .id))
            .field("user",.uuid,.required,.references("users", .id))
            .field("aimUser",.uuid,.required,.references("users", .id))
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("nestReplys").delete()
    }
}
