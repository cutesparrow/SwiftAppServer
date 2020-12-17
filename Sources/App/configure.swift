import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    //database
    app.databases.use(.postgres(hostname: Environment.get("DATABASE_HOST") ?? "localhost", username: Environment.get("DATABASE_USERNAME") ?? "gaoyushi", password: "", database: "gaoyushi"), as: .psql)
    app.migrations.add(CreateUser())
    app.migrations.add(CreateMission())
    app.migrations.add(CreateMissionFile())
    app.migrations.add(CreateBet())
    app.migrations.add(CreateLanguage())
    app.migrations.add(CreateWorkerLanguage())
    app.migrations.add(CreateMissionLanguage())
    app.migrations.add(CreateReply())
    app.migrations.add(CreateNestReply())
    app.migrations.add(CreateUserToken())
    
    
    
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()

    
    // register routes
    try routes(app)
}
