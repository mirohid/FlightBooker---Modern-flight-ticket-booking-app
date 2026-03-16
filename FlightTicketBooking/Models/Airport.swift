import Foundation

struct Airport: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let city: String
    let name: String
    let country: String
}
