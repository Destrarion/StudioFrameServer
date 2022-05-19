import Fluent
import Vapor

final class UsdzObject: Model, Content {
    static let schema = "usdz_objects"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "object_url_string")
    var objectUrlString: String
    
    @Field(key: "thumbnail_image_url_string")
    var thumbnailImageUrlString: String

    init() { }

    init(id: UUID? = nil, title: String, objectUrlString: String, thumbnailImageUrlString: String) {
        self.id = id
        self.title = title
        self.objectUrlString = objectUrlString
        self.thumbnailImageUrlString = thumbnailImageUrlString
    }
}
