import Foundation
import CoreLocation

enum MemberStatus: String, Codable {
    case safe = "safe"
    case alert = "alert"
    case sos = "sos"
}

struct CircleMember: Identifiable, Codable {
    let id: UUID
    let name: String
    let walletAddress: String
    var latitude: Double
    var longitude: Double
    var status: MemberStatus
    var lastSeen: Date
    var batteryLevel: Float
    
    var coordinate: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}
