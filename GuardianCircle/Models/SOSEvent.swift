import Foundation
import CoreLocation

struct SOSEvent: Identifiable, Codable {
    let id: UUID
    let triggeredBy: String // Wallet address
    let circleId: String
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let txHash: String // Blockchain transaction hash
    let isConfirmed: Bool
    
    var coordinate: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    }
}
