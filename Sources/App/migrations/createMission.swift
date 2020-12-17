//
//  File.swift
//  
//
//  Created by gaoyu shi on 14/12/20.
//
import Fluent
import Vapor
import Foundation

struct CreateMission:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("missions")
            .id()
            .field("title",.string,.required)
            .field("type",.string,.required)
            .field("date",.date,.required)
            .field("price",.int,.required)
            .field("status",.string,.required)
            .field("content",.string)
            .field("user",.uuid,.required,.references("users", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("missions").delete()
    }
}
