import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    try app.register(collection: MissionController())
    try app.register(collection: BetController())
    try app.register(collection: NestReplyController())
    try app.register(collection: UserController())
    try app.register(collection: ReplyController())
    
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
