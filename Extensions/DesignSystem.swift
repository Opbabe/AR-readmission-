import SwiftUI

// MARK: - Design System for Apple Vision Pro Medical App

struct DesignSystem {
    // MARK: - Semantic Colors
    struct Colors {
        // Risk bands with semantic colors
        static let riskLow = Color.green.opacity(0.8)
        static let riskMedium = Color.orange.opacity(0.8)
        static let riskHigh = Color.red.opacity(0.8)
        
        // Medical/clinical palette
        static let primary = Color.accentColor
        static let secondary = Color.secondary
        
        // Glass materials
        static let glassLight = Color.white.opacity(0.1)
        static let glassBorder = Color.white.opacity(0.15)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title, design: .rounded, weight: .bold)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
        static let title3 = Font.system(.title3, design: .rounded, weight: .semibold)
        static let headline = Font.system(.headline, design: .default, weight: .semibold)
        static let body = Font.system(.body, design: .default)
        static let callout = Font.system(.callout, design: .default)
        static let subheadline = Font.system(.subheadline, design: .default)
        static let caption = Font.system(.caption, design: .default)
        static let caption2 = Font.system(.caption2, design: .default)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 20
        static let large: CGFloat = 28
        static let capsule: CGFloat = 999
    }
    
    // MARK: - Animations
    struct Animations {
        static let spring = Animation.spring(response: 0.4, dampingFraction: 0.85)
        static let gentleSpring = Animation.spring(response: 0.5, dampingFraction: 0.9)
        static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.8)
        
        static func transition(_ transitions: AnyTransition...) -> AnyTransition {
            transitions.reduce(.identity) { $0.combined(with: $1) }
        }
    }
    
    // MARK: - Risk Band Helper
    static func riskColor(for band: String) -> Color {
        switch band.lowercased() {
        case "low":
            return Colors.riskLow
        case "med", "medium":
            return Colors.riskMedium
        case "high":
            return Colors.riskHigh
        default:
            return Colors.riskMedium
        }
    }
    
    static func riskColorSystem(for band: String) -> Color {
        switch band.lowercased() {
        case "low":
            return .green
        case "med", "medium":
            return .orange
        case "high":
            return .red
        default:
            return .orange
        }
    }
}

// MARK: - Glass Card Modifier
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignSystem.CornerRadius.medium
    
    func body(content: Content) -> some View {
        content
            .padding(DesignSystem.Spacing.md)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = DesignSystem.CornerRadius.medium) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}

