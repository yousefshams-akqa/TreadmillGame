import Foundation

struct UserModel: Codable, Hashable {
    var name: String
    var age: String
    var weight: String
    var height: String
    
    // MARK: - Persistence
    
    private static let userDefaultsKey = "user"
    
    /// Save user to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
    
    /// Load user from UserDefaults, or return nil if not found
    static func load() -> UserModel? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let user = try? JSONDecoder().decode(UserModel.self, from: data) else {
            return nil
        }
        return user
    }
}
