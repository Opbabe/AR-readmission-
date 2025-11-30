import SwiftUI

struct PatientCard: View {
    let p: Patient
    @State private var expanded = false
    @State private var lang: Lang = .en
    
    enum Lang: String, CaseIterable {
        case en = "EN"
        case es = "ES"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            // Header
            headerSection
            
            // Risk section
            riskSection
            
            // Drivers section
            driversSection
            
            // Expanded details
            if expanded {
                Divider()
                    .padding(.vertical, DesignSystem.Spacing.xs)
                
                expandedSection
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Actions
            actionButtons
            
            // Disclaimer
            disclaimer
        }
        .padding(DesignSystem.Spacing.lg)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: DesignSystem.CornerRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text("Patient Card")
                    .font(DesignSystem.Typography.title2)
                Text("\(p.name) • Room \(p.room)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Picker("", selection: $lang) {
                ForEach(Lang.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 100)
        }
    }
    
    // MARK: - Risk Section
    private var riskSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.md) {
                EnhancedRiskChip(band: p.risk_band)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(String(format: "%.0f%%", p.risk_score * 100))
                        .font(DesignSystem.Typography.title)
                        .foregroundStyle(DesignSystem.riskColorSystem(for: p.risk_band))
                    Text("Risk Score")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Drivers Section
    private var driversSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Top Drivers")
                .font(DesignSystem.Typography.headline)
            
            Wrap(tags: p.drivers + p.alerts.map { "⚠️ " + $0 })
        }
    }
    
    // MARK: - Expanded Section
    private var expandedSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(lang == .en ? "Care Plan" : "Plan de Cuidados")
                .font(DesignSystem.Typography.headline)
            
            Text(lang == .en ? p.teachback_plan : spanishPlan)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .animation(DesignSystem.Animations.spring, value: expanded)
    }
    
    private var spanishPlan: String {
        // Simplified Spanish translation
        switch p.risk_band.lowercased() {
        case "high":
            return "Seguimiento ≤ 7 días; reconciliación de medicamentos; enseñanza de diabetes."
        case "med", "medium":
            return "Llamada a clínica en 3–5 días; revisión de registro de glucosa; reforzar medicamentos."
        default:
            return "Seguimiento estándar; materiales de dieta y actividad; médico de cabecera en 2–3 semanas."
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        Button {
            withAnimation(DesignSystem.Animations.spring) {
                expanded.toggle()
            }
        } label: {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                Text(expanded ? "Hide Details" : "Show Details")
                    .font(DesignSystem.Typography.callout)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
        .buttonStyle(.borderedProminent)
    }
    
    // MARK: - Disclaimer
    private var disclaimer: some View {
        Text("Not for clinical use. Demo only.")
            .font(DesignSystem.Typography.caption2)
            .foregroundStyle(.secondary)
            .padding(.top, DesignSystem.Spacing.xs)
    }
}

// MARK: - Enhanced Risk Chip

struct EnhancedRiskChip: View {
    let band: String
    
    private var color: Color {
        DesignSystem.riskColorSystem(for: band)
    }
    
    private var label: String {
        switch band.lowercased() {
        case "low":
            return "Low Risk"
        case "med", "medium":
            return "Medium Risk"
        default:
            return "High Risk"
        }
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .shadow(color: color.opacity(0.5), radius: 4)
            
            Text(label)
                .font(DesignSystem.Typography.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(.thinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .strokeBorder(color.opacity(0.3), lineWidth: 1.5)
        )
    }
}

// MARK: - Wrap Component (unchanged but styled)

struct Wrap: View {
    let tags: [String]
    var body: some View {
        FlowLayout(tags, spacing: DesignSystem.Spacing.sm) { tag in
            Text(tag)
                .font(DesignSystem.Typography.caption)
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.xs + 2)
                .background(.thinMaterial, in: Capsule())
                .overlay(Capsule().strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1))
        }
    }
}

// MARK: - Flow Layout (unchanged)

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element == String {
    let data: Data
    let spacing: CGFloat
    let content: (String) -> Content
    
    init(_ data: Data, spacing: CGFloat, @ViewBuilder content: @escaping (String) -> Content) {
        self.data = data
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        var x: CGFloat = 0
        var y: CGFloat = 0
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                    content(item)
                        .padding(.trailing, spacing)
                        .alignmentGuide(.leading) { d in
                            if x + d.width > geo.size.width {
                                x = 0
                                y -= d.height + spacing
                            }
                            defer { x += d.width }
                            return x - d.width
                        }
                        .alignmentGuide(.top) { _ in y }
                }
            }
        }
        .frame(minHeight: 24)
    }
}
