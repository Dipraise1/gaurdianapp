import Foundation
import AppIntents

@available(iOS 16.0, *)
struct TriggerSOSIntent: AppIntent {
    static var title: LocalizedStringResource = "Guardian SOS Alert"
    static var description = IntentDescription("Alert your Guardian Circle in an emergency using Web3 smart contracts.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Trigger the emergency transaction and broadcast location
        await SOSService.shared.triggerEmergency()
        
        // Return a dialog for Siri to speak
        return .result(dialog: "SOS sent to your Guardian Circle.")
    }
}

// Ensure the AppIntent is discoverable
@available(iOS 16.0, *)
struct GuardianCircleShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TriggerSOSIntent(),
            phrases: [
                "Trigger SOS on \(.applicationName)",
                "\(.applicationName) SOS",
                "Alert Guardian Circle"
            ],
            shortTitle: "Guardian SOS",
            systemImageName: "exclamationmark.triangle.fill"
        )
    }
}
