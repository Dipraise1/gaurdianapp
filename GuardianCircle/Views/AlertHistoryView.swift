import SwiftUI

struct AlertHistoryView: View {
    // In production, fetch from Polygon via Web3Manager
    let mockEvents: [SOSEvent] = [
        SOSEvent(
            id: UUID(),
            triggeredBy: "0x742d35Cc6634C0532925a3b844Bc454e4438f44e",
            circleId: "Family_Circle_01",
            latitude: 37.7749,
            longitude: -122.4194,
            timestamp: Date().addingTimeInterval(-86400),
            txHash: "0xabc123...def456",
            isConfirmed: true
        ),
        SOSEvent(
            id: UUID(),
            triggeredBy: "0x123...456",
            circleId: "Family_Circle_01",
            latitude: 37.7858,
            longitude: -122.4064,
            timestamp: Date().addingTimeInterval(-172800),
            txHash: "0xdef456...ghi789",
            isConfirmed: true
        )
    ]
    
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            NavigationView {
                ZStack {
                    Color.clear
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(mockEvents) { event in
                                HistoryCardView(event: event)
                            }
                        }
                        .padding()
                        .padding(.top, 20)
                    }
                }
                .navigationTitle("Alert History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "arrow.down.doc.fill")
                                .foregroundColor(Theme.primary)
                                .padding(8)
                                .glassCard(cornerRadius: 12)
                        }
                    }
                }
            }
            .accentColor(Theme.primary)
        }
    }
}

struct HistoryCardView: View {
    let event: SOSEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Theme.emergency.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "exclamationmark.shield.fill")
                        .foregroundColor(Theme.emergency)
                        .symbolEffect(.pulse, options: .repeating)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Emergency SOS")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(event.timestamp, style: .date)
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                Spacer()
                
                Text("CONFIRMED")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(Theme.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primary.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.caption2)
                        .foregroundColor(Theme.primary)
                    Text("By: \(event.triggeredBy)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                        .foregroundColor(Theme.primary)
                    Text("\(String(format: "%.4f", event.latitude)), \(String(format: "%.4f", event.longitude))")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Link(destination: URL(string: "https://polygonscan.com/tx/\(event.txHash)")!) {
                HStack {
                    Text("View on Polygonscan")
                        .font(.system(size: 12, weight: .bold))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10))
                }
                .foregroundColor(Theme.primary)
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 24)
    }
}
