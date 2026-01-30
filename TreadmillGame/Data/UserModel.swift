struct UserModel : Codable, Hashable {
    var name : String
    var age : String
    var weight : String
    var height : String
    
    func toJson() -> Dictionary<String, Any> {
        return [
            "name" : name,
            "age" : age,
            "weight" : weight,
            "height" : height
        ]
    }
    
    static func fromJson(data: Dictionary<String, Any>) -> UserModel  {
        return UserModel(name: data["name"] as! String, age: data["age"] as! String, weight: data["weight"] as! String, height: data["height"] as! String)
    }
}
