import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    
    if app.environment == .development {
            app.http.server.configuration.hostname = "0.0.0.0"
        }
    
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
            username: Environment.get("DATABASE_USERNAME") ?? "postgres",//"postgres",//"vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",//"vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "postgres"
        ), as: .psql)
    }
    
    
    
    
    app.migrations.add(CreateUsdzObject())
    app.migrations.add(UsdzObject.SeedsMigration())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
