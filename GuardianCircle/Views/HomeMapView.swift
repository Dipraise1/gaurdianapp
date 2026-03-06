import SwiftUI
import MapKit

struct HomeMapView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Dummy Data for Map
    @State private var mockMembers: [CircleMember] = [
        CircleMember(id: UUID(), name: "Alice", walletAddress: "0x123", latitude: 37.775, longitude: -122.418, status: .safe, lastSeen: Date(), batteryLevel: 0.8),
        CircleMember(id: UUID(), name: "Bob", walletAddress: "0x456", latitude: 37.771, longitude: -122.422, status: .alert, lastSeen: Date(), batteryLevel: 0.2)
    ]
    
    @State private var showingSOS = false
    @State private var selectedMember: CircleMember?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: mockMembers) { member in
                MapAnnotation(coordinate: member.coordinate) {
                    MemberPinView(member: member)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedMember = member
                            }
                        }
                }
            }
            .ignoresSafeArea()
            .onReceive(locationManager.$userLocation) { location in
                if let location = location {
                    withAnimation(.easeInOut) {
                        region.center = location
                    }
                }
            }
            
            // Top Overlay for Status
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Guardian Circle")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                        Text("2 Members Online")
                            .font(.caption)
                            .foregroundColor(Theme.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .glassCard(cornerRadius: 16)
                    
                    Spacer()
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        showingSOS = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Theme.emergency.opacity(0.2))
                                .frame(width: 64, height: 64)
                                .symbolEffect(.pulse, options: .repeating)
                            
                            Image(systemName: "sos")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(Theme.emergency)
                                .clipShape(Circle())
                                .shadow(color: Theme.emergency.opacity(0.5), radius: 10)
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                Spacer()
            }
            
            // Bottom Sheet
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.vertical, 12)
                
                CircleBottomSheetView(members: mockMembers)
                    .padding(.bottom, 30)
            }
            .glassCard(cornerRadius: 32)
            .padding(.horizontal, 8)
            .padding(.bottom, 10)
        }
        .fullScreenCover(isPresented: $showingSOS) {
            SOSView(isPresented: $showingSOS)
        }
        .preferredColorScheme(.dark)
    }
}

struct MemberPinView: View {
    let member: CircleMember
    
    var statusColor: Color {
        switch member.status {
        case .safe: return Theme.primary
        case .alert: return .orange
        case .sos: return Theme.emergency
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Outer Pulse for SOS or Alert
                if member.status != .safe {
                    Circle()
                        .stroke(statusColor.opacity(0.5), lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .scaleEffect(1.2)
                        .symbolEffect(.pulse, options: .repeating)
                }
                
                // Avatar background
                Circle()
                    .fill(statusColor)
                    .frame(width: 40, height: 40)
                    .shadow(color: statusColor.opacity(0.4), radius: 8)
                
                // Initial or Icon
                Text(String(member.name.prefix(1)))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.black)
                
                // Badge for Battery
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(member.batteryLevel < 0.2 ? .red : .green)
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    }
                }
                .frame(width: 40, height: 40)
            }
            
            // Stem
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 8, height: 6)
                .foregroundColor(statusColor)
                .rotationEffect(.degrees(180))
                .offset(y: -1)
        }
    }
}
