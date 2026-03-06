import SwiftUI

struct SettingsView: View {
    @State private var shareLocationAlways = true
    @State private var walletAddress = Web3Manager.shared.walletAddress()
    
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            NavigationView {
                ZStack {
                    Color.clear
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Profile Section
                            VStack(spacing: 12) {
                                Circle()
                                    .fill(Theme.primary.gradient)
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.black)
                                    )
                                
                                Text("Guardian Admin")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                            
                            // Privacy Settings
                            VStack(alignment: .leading, spacing: 16) {
                                Label("Privacy & Sharing", systemImage: "lock.shield.fill")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(Theme.primary)
                                
                                Toggle("Persistent Location Sharing", isOn: $shareLocationAlways)
                                    .tint(Theme.primary)
                                
                                Text("If disabled, location is only shared during an active SOS.")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(20)
                            .glassCard(cornerRadius: 24)
                            
                            // Web3 Section
                            VStack(alignment: .leading, spacing: 16) {
                                Label("Web3 Identity", systemImage: "wallet.pass.fill")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(Theme.primary)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Polygon Wallet")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                        Text(walletAddress.prefix(8) + "..." + walletAddress.suffix(6))
                                            .font(.system(.subheadline, design: .monospaced))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    Button(action: {
                                        UIPasteboard.general.string = walletAddress
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }) {
                                        Image(systemName: "doc.on.doc.fill")
                                            .foregroundColor(Theme.primary)
                                            .padding(8)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Button(action: {}) {
                                    HStack {
                                        Text("Export Primary Key")
                                        Spacer()
                                        Image(systemName: "key.fill")
                                    }
                                    .foregroundColor(Theme.emergency)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                }
                            }
                            .padding(20)
                            .glassCard(cornerRadius: 24)
                            
                            // Shortcuts
                            VStack(alignment: .leading, spacing: 16) {
                                Label("Siri Shortcuts", systemImage: "mic.fill")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(Theme.primary)
                                
                                Text("Say \"Hey Siri, Guardian SOS\" to silently trigger an emergency alert.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Configure Siri Command")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.primary.opacity(0.1))
                                    .foregroundColor(Theme.primary)
                                    .cornerRadius(16)
                                }
                            }
                            .padding(20)
                            .glassCard(cornerRadius: 24)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Settings")
            }
            .accentColor(Theme.primary)
        }
    }
}
