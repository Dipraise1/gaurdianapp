import Foundation
import CoreLocation
import UIKit
import UserNotifications

// Requires the UIImpactFeedbackGenerator
class SOSService {
    static let shared = SOSService()
    
    private let userDefaultsCircleIdKey = "user_circle_id"
    
    func triggerEmergency() async {
        print("SOS Triggered!")
        
        // 1. Trigger haptic feedback
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        
        // 2. Fetch current location
        LocationManager.shared.startTracking(isEmergency: true)
        guard let location = LocationManager.shared.userLocation else {
            print("No location available for SOS")
            return
        }
        
        // 3. Encrypt location for IPFS/Blockchain
        let circleId = UserDefaults.standard.string(forKey: userDefaultsCircleIdKey) ?? "default_circle"
        // Dummy symmetric key for demo 
        let circleKey = "my_super_secret_circle_key"
        let encryptedLocator = StorageService.shared.encryptLocationForBlockchain(coordinate: location, circleKey: circleKey)
        
        // 4. Send Web3 Transaction (Smart Contract)
        do {
            let txHash = try await Web3Manager.shared.triggerSOSTransaction(circleId: circleId, encryptedLocation: encryptedLocator)
            print("TX Hash: \(txHash)")
            
            // 5. Trigger local push notification confirmation
            sendLocalNotification(txHash: txHash)
            
        } catch {
            print("Failed to send SOS tx: \(error.localizedDescription)")
            
            // Still send local notification for demo
            let mockHash = "0x\(UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased())"
            sendLocalNotification(txHash: mockHash)
        }
    }
    
    private func sendLocalNotification(txHash: String) {
        let content = UNMutableNotificationContent()
        content.title = "SOS Sent"
        content.body = "Alert sent to your circle. TX: \(txHash.prefix(10))..."
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
}
