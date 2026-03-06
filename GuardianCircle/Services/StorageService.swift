import Foundation
import CoreLocation

// A placeholder for IPFS (Pinata/Infura) + AES-256 encryption.
struct StorageService {
    static let shared = StorageService()
    
    // Simulate encrypting coordinate into an AES-256 string for Web3
    func encryptLocationForBlockchain(coordinate: CLLocationCoordinate2D, circleKey: String) -> String {
        // In reality, this would serialize the coordinate + timestamp,
        // encrypt via AES-GCM with 'circleKey', and upload to IPFS.
        // Returning a mock IPFS CID / encrypted payload string.
        let payload = "\(coordinate.latitude),\(coordinate.longitude)"
        let mockEncrypted = payload.data(using: .utf8)?.base64EncodedString() ?? "encrypted"
        return "ipfs://mock_cid_\(mockEncrypted)"
    }
    
    func decryptLocationFromBlockchain(encryptedData: String, circleKey: String) -> CLLocationCoordinate2D? {
        // In reality, this would fetch from IPFS (if it's a CID) 
        // and decrypt using AES-GCM with 'circleKey'.
        guard encryptedData.hasPrefix("ipfs://mock_cid_") else { return nil }
        let b64 = encryptedData.replacingOccurrences(of: "ipfs://mock_cid_", with: "")
        guard let data = Data(base64Encoded: b64),
              let payload = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let components = payload.split(separator: ",")
        if components.count == 2,
           let lat = Double(components[0]),
           let lon = Double(components[1]) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        return nil
    }
}
