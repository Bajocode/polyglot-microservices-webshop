import Vapor

struct PaymentController: RouteCollection {
    private func charge(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return req
    }
}
