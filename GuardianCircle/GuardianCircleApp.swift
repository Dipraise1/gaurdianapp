import SwiftUI

@main
struct GuardianCircleApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Global Navigation Bar Appearance (Glassmorphic vibe)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: .black)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 40, weight: .black)]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            CircleView(members: [
                CircleMember(id: UUID(), name: "Alice", walletAddress: "0x123", latitude: 37.775, longitude: -122.418, status: .safe, lastSeen: Date(), batteryLevel: 0.8),
                CircleMember(id: UUID(), name: "Bob", walletAddress: "0x456", latitude: 37.771, longitude: -122.422, status: .alert, lastSeen: Date(), batteryLevel: 0.2)
            ])
            .tabItem {
                Label("Circle", systemImage: "person.2.fill")
            }
            
            AlertHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(Theme.primary)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Request notifications for SOS alerts
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permission granted: \(granted)")
        }
        
        return true
    }
    
    // Show notification even when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
