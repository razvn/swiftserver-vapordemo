import Vapor
import VaporPostgreSQL

let drop = Droplet(
	preparations: [User.self],
    providers: [VaporPostgreSQL.Provider.self]
)

drop.get { req in
    return try JSON(node: ["message": "Hello from Vapor!"])
}

drop.get("hello") { request in
		return try JSON(node: [
			"message": "Hello, again!"
        ])
}

drop.get("hello", "there") { request in
		return try JSON(node: [
			"message": "Hello, again and again, again !"
		])
}

drop.get("bieres", Int.self) { request, bieres in
		return try JSON(node: [
			"message": "Une bière pour toi il ne reste plus que \(bieres - 1) ..."
		])
}

drop.get("users") { req in
    return try JSON(node: User.all().makeNode())
}

drop.get("createusers") { req in
    var user =  User(name: "Tim", beer: 12)
    try user.save()
    user =  User(name: "Craig", beer: 39)
    try user.save()
    user =  User(name: "Phil",  beer: nil)
    try user.save()
    return try JSON(node: User.all().makeNode())
}

drop.get("user", Int.self) { req, userID in
    guard let user = try User.find(userID) else {
        throw Abort.notFound
     }
    return try user.makeJSON() 
}

drop.post("user") { req in
    var user = try User(node: req.json)
    try user.save()
    return try user.makeJSON()
}

drop.get("temp") { req in
    
    //service URL
    let URL = "http://api.openweathermap.org/data/2.5/weather"
 
    //the query data
    let QUERY =  "Montpellier,FR"
    //the APPID to use with openweathermap service
    let APIKEY = ""
 
    //make the query with passing the query params 
    let response = try drop.client.get(URL, query: ["q": QUERY, "APPID":APIKEY, "units":"metric"])
 
    print(response)

	guard let temperature = response.data["main", "temp"]?.string else {
        return "Temperature inconnue pour Montpellier"
    }
 
    return "Montpellier temperature is: \(temperature) °C"
}

drop.run()
