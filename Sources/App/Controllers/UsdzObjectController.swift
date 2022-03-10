import Fluent
import Vapor

struct UsdzObjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("usdz-objects")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":usdz-object-ID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [UsdzObject] {
        try await UsdzObject.query(on: req.db).all()
    }

    func create(req: Request) async throws -> UsdzObject {
        let todo = try req.content.decode(UsdzObject.self)
        try await todo.save(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await UsdzObject.find(req.parameters.get("usdz-object-ID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .ok
    }
}
