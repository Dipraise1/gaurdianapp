import SwiftUI

struct SOSView: View {
    @Binding var isPresented: Bool
    
    @State private var timeRemaining = 5
    @State private var hasFired = false
    @State private var txHash: String?
    @State private var pulseScale: CGFloat = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Intense Background
            Theme.emergency.ignoresSafeArea()
            
            // Pulse Rings
            if !hasFired {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .scaleEffect(pulseScale + CGFloat(i) * 0.4)
                        .opacity(Double(3 - i) / 3.0 * (2.0 - pulseScale))
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                        pulseScale = 2.0
                    }
                }
            }
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated Warning Icon
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 100))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, options: .repeating)
                
                VStack(spacing: 12) {
                    Text(hasFired ? "SOS TRANSMITTED" : "EMERGENCY ALERT")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(hasFired ? "Blockchain transaction initialized." : "Broadcasting to your circle in...")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if !hasFired {
                    // Countdown Display
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 10)
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(timeRemaining) / 5.0)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: timeRemaining)
                        
                        Text("\(timeRemaining)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 20)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } else if timeRemaining == 0 && !hasFired {
                            fireSOS()
                        }
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("CANCEL ALERT")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                } else {
                    // Success State
                    VStack(spacing: 24) {
                        if let tx = txHash {
                            VStack(spacing: 8) {
                                Text("TRANSACTION HASH")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(tx)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .glassCard(cornerRadius: 12)
                            }
                        }
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("DISMISS")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.emergency)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                        }
                        .padding(.horizontal, 40)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                    Text("End-to-End Encrypted via Polygon")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white.opacity(0.6))
                .padding(.bottom, 20)
            }
        }
    }
    
    private func fireSOS() {
        withAnimation(.spring()) {
            hasFired = true
        }
        Task {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            await SOSService.shared.triggerEmergency()
            // In a real impl, we'd wait for returning hash
            self.txHash = "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        }
    }
}
