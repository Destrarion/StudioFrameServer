import Vapor
import FluentKit

extension UsdzObject {
    struct SeedsMigration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.transaction { database in
                try await UsdzObject(title: "tv_retro", objectUrlString: "tv_retro.usdz", thumbnailImageUrlString: "tv_retroThumbnail.png").save(on: database)
                try await UsdzObject(title: "PegasusTrail", objectUrlString: "PegasusTrail.usdz", thumbnailImageUrlString: "PegasusTrailThumbnail.png").save(on: database)
                try await UsdzObject(title: "SofaFurniture", objectUrlString: "SofaFurniture.usdz", thumbnailImageUrlString: "SofaFurnitureThumbnail.png").save(on: database)
            }
        }
        
        func revert(on database: Database) async throws {
            try await UsdzObject.query(on: Database.self  as! Database).delete()
        }
    }
}
