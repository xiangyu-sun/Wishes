import Vapor

class PasswordValidator: ValidationSuite {
  static func validate(input value: String) throws {
    let range = value.range(of: "^(?=.*[0-9])(?=.*[A-Z])", options: .regularExpression)
    guard let _ = range else {
      throw error(with: value)
    }
  }
}
