import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var walletAddress: String = ""
    @State private var isAnimatingIcon = false
    
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated Premium Icon
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.15))
                        .frame(width: 160, height: 160)
                        .blur(radius: isAnimatingIcon ? 20 : 10)
                        .scaleEffect(isAnimatingIcon ? 1.2 : 1.0)
                    
                    Image(systemName: "shield.lefthalf.filled.badge.check")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, Theme.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.pulse.byLayer, options: .repeating)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isAnimatingIcon = true
                    }
                }
                
                VStack(spacing: 12) {
                    Text("Guardian Circle")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                    
                    Text("The Future of Family Safety")
                        .font(.headline)
                        .foregroundStyle(Theme.primary)
                    
                    Text("Secure, Decentralized, and Private.\nYour circle, your control.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.6))
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Glass Card for Wallet & Actions
                VStack(spacing: 20) {
                    if walletAddress.isEmpty {
                        Button(action: {
                            withAnimation(.spring()) {
                                Web3Manager.shared.loadOrCreateAccount()
                                walletAddress = Web3Manager.shared.walletAddress()
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }) {
                            HStack {
                                Image(systemName: "wallet.pass.fill")
                                Text("Generate Secure Wallet")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .cornerRadius(16)
                            .shadow(color: Theme.primary.opacity(0.4), radius: 15, x: 0, y: 10)
                        }
                    } else {
                        VStack(spacing: 12) {
                             HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(Theme.primary)
                                Text("Wallet Securely Initialized")
                                    .fontWeight(.bold)
                            }
                            
                            Text(walletAddress)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                                .lineLimit(1)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    LocationManager.shared.requestPermissions()
                                    hasCompletedOnboarding = true
                                    UIImpactFeedbackGenerator(style: .success).impactOccurred()
                                }
                            }) {
                                Text("Grant Permissions & Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [Theme.primary, Color.blue], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(16)
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(24)
                .glassCard()
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}
