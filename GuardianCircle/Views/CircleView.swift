import SwiftUI

struct CircleView: View {
    let members: [CircleMember]
    
    var body: some View {
        ZStack {
            MeshGradientBackground()
            
            NavigationView {
                ZStack {
                    Color.clear // Allow mesh to show through
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(members) { member in
                                MemberCardView(member: member)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                            }
                        }
                        .padding()
                        .padding(.top, 20)
                    }
                }
                .navigationTitle("Your Circle")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 18, weight: .bold))
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

struct MemberCardView: View {
    let member: CircleMember
    
    var statusColor: Color {
        switch member.status {
        case .safe: return Theme.primary
        case .alert: return .orange
        case .sos: return Theme.emergency
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar with Status Ring
            ZStack {
                Circle()
                    .stroke(statusColor.opacity(0.3), lineWidth: 3)
                    .frame(width: 56, height: 56)
                
                Circle()
                    .fill(statusColor.gradient)
                    .frame(width: 48, height: 48)
                
                Text(String(member.name.prefix(1)))
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    
                    Text(statusText(for: member.status))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 4) {
                    Text("\(Int(member.batteryLevel * 100))%")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(member.batteryLevel < 0.2 ? Theme.emergency : .white.opacity(0.6))
                    
                    Image(systemName: batteryIcon(for: member.batteryLevel))
                        .font(.caption2)
                        .foregroundColor(member.batteryLevel < 0.2 ? Theme.emergency : .white.opacity(0.6))
                }
                
                Text(timeAgo(from: member.lastSeen))
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 20)
    }
    
    private func statusText(for status: MemberStatus) -> String {
        switch status {
        case .safe: return "Safe"
        case .alert: return "Alert Triggered"
        case .sos: return "S.O.S Active"
        }
    }
    
    private func batteryIcon(for level: Float) -> String {
        if level > 0.8 { return "battery.100" }
        if level > 0.5 { return "battery.75" }
        if level > 0.2 { return "battery.50" }
        return "battery.25"
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
