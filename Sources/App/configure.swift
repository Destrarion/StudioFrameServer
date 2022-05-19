import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    if let databaseURL = Environment.databaseURL,
       var postgresConfiguration = PostgresConfiguration(url: databaseURL)
    {
        postgresConfiguration.tlsConfiguration = .makeClientConfiguration()
        postgresConfiguration.tlsConfiguration?.certificateVerification = .none
        
        app.databases.use(
            .postgres(configuration: postgresConfiguration),
            as: .psql
        )
        
    } else {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor-admin",//"postgres",//"vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "password",//"vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor-db"
        ), as: .psql)
    }
    
    
    
    
    app.migrations.add(CreateUsdzObject())
    app.migrations.add(UsdzObject.SeedsMigration())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
