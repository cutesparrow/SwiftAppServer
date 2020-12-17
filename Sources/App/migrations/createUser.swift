//
//  File.swift
//  
//
//  Created by gaoyu shi on 14/12/20.
//
import Fluent
import Foundation
import Vapor

struct CreateUser:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("account",.string,.required).unique(on: "account")
            .field("password",.string,.required)
            .field("sex",.string,.required)
            .field("birthday",.date,.required)
            .field("email",.string,.required)
            .field("icon",.string)
            .create()
        
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

