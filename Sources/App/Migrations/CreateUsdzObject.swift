import Fluent

struct CreateUsdzObject: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("usdz_objects")
            .id()
            .field("title", .string, .required)
            .field("object_url_string", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("usdz_objects").delete()
    }
}
