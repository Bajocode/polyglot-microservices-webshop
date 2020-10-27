import Vapor

func routes(_ app: Application) throws {
    app.group("payments") { (routesBuilder) in
        try! routesBuilder.register(collection: PaymentController())
    }
    
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
