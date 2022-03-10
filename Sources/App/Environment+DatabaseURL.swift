import Foundation

import Vapor

extension Environment {
    
    static var databaseURL: URL? {
        guard let urlString = Environment.get("DATABASE_URL"), let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
