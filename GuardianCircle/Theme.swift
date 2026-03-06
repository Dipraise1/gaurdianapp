import SwiftUI

/// Guardian Circle Design System 2026
enum Theme {
    static let primary = Color(red: 0.4, blue: 1.0, green: 0.6) // Vibrant Mint/Cyan
    static let secondary = Color(red: 0.6, blue: 0.9, green: 1.0)
    static let emergency = Color(red: 1.0, green: 0.2, blue: 0.3) // High-intensity Red
    static let background = Color.black
    
    // Glassmorphic styling
    static let glassGradient = LinearGradient(
        colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GlassViewModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
            .background(Theme.glassGradient)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(GlassViewModifier(cornerRadius: cornerRadius))
    }
}

struct MeshGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            // Dynamic Mesh effect using elliptical gradients
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                Canvas { context, size in
                    let w = size.width
                    let h = size.height
                    
                    // Simple simulated mesh logic
                    for i in 0..<3 {
                        let x = w * (0.5 + 0.3 * cos(time * 0.5 + Double(i)))
                        let y = h * (0.5 + 0.3 * sin(time * 0.7 + Double(i)))
                        let radius = w * 0.8
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x - radius/2, y: y - radius/2, width: radius, height: radius)),
                            with: .radialGradient(
                                Gradient(colors: [Theme.primary.opacity(0.15), .clear]),
                                center: CGPoint(x: x, y: y),
                                startRadius: 0,
                                endRadius: radius/2
                            )
                        )
                    }
                }
            }
            .blur(radius: 60)
        }
        .ignoresSafeArea()
    }
}
