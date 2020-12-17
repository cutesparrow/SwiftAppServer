//
//  File.swift
//  
//
//  Created by gaoyu shi on 15/12/20.
//
import Fluent
import Vapor
import Foundation


struct CreateMissionFile:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("missionFiles")
            .id()
            .field("name",.string,.required)
            .field("path",.string,.required)
            .field("mission",.uuid,.required,.references("missions", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("missionFiles").delete()
    }
}
