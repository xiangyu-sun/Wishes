import Vapor

class URLValidator: ValidationSuite {
    static func validate(input value: String) throws {
        let range = value.range(of: "^(https?://)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([/\\w \\.-]*)*/?$", options: .regularExpression)
        guard let _ = range else {
            throw error(with: value)
        }
    
        
    }
}
