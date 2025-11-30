import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var searchText = ""
    @State private var appear = false
    
    private var filteredResults: [DiabetesRiskResult] {
        if searchText.isEmpty {
            return model.riskResults
        }
        return model.riskResults.filter { result in
            result.patient.name.localizedCaseInsensitiveContains(searchText) ||
            result.patient.room.localizedCaseInsensitiveContains(searchText) ||
            result.patient.patient_id.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xl) {
            // Left: Controls and patient selection
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Header
                headerSection
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : -20)
                
                // Search bar
                searchSection
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : -20)
                    .animation(DesignSystem.Animations.spring.delay(0.1), value: appear)
                
                // Patient selection list
                patientSelectionSection
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : -20)
                    .animation(DesignSystem.Animations.spring.delay(0.2), value: appear)
                
                // Action buttons
                actionButtonsSection
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : -20)
                    .animation(DesignSystem.Animations.spring.delay(0.3), value: appear)
                
                // About section
                aboutSection
                    .opacity(appear ? 1 : 0)
                    .offset(x: appear ? 0 : -20)
                    .animation(DesignSystem.Animations.spring.delay(0.4), value: appear)
                
                Spacer()
            }
            .frame(maxWidth: 400)
            
            // Right: Patient card preview
            previewSection
                .opacity(appear ? 1 : 0)
                .offset(x: appear ? 0 : 20)
                .animation(DesignSystem.Animations.spring.delay(0.2), value: appear)
        }
        .padding(DesignSystem.Spacing.xl)
        .background(
            LinearGradient(
                colors: [
                    Color.teal.opacity(0.08),
                    Color.blue.opacity(0.04),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            withAnimation(DesignSystem.Animations.spring) {
                appear = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "stethoscope")
                    .foregroundStyle(.accent)
                Text("Diabetes Risk Nurse")
                    .font(DesignSystem.Typography.largeTitle)
            }
            
            Text("Not for clinical use. Demo only.")
                .font(DesignSystem.Typography.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search by name or room", text: $searchText)
                .textFieldStyle(.plain)
                .font(DesignSystem.Typography.body)
        }
        .padding(DesignSystem.Spacing.md)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: DesignSystem.CornerRadius.small))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Patient Selection Section
    private var patientSelectionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Select Patient")
                    .font(DesignSystem.Typography.headline)
                Spacer()
                if !searchText.isEmpty {
                    Text("\(filteredResults.count) found")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(filteredResults) { result in
                        PatientSelectionCard(
                            result: result,
                            isSelected: model.selectedRiskResult?.patient.id == result.patient.id,
                            onSelect: {
                                withAnimation(DesignSystem.Animations.quickSpring) {
                                    model.select(riskResult: result)
                                }
                            }
                        )
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .glassCard()
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Button {
                Task {
                    await openImmersiveSpace(id: model.immersiveSpaceID)
                }
            } label: {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "visionpro")
                    Text("Enter Mixed Reality")
                        .font(DesignSystem.Typography.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(
                    LinearGradient(
                        colors: model.selectedRiskResult != nil
                        ? [Color.accentColor, Color.teal]
                        : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(DesignSystem.CornerRadius.medium)
                .shadow(
                    color: model.selectedRiskResult != nil
                    ? Color.accentColor.opacity(0.3)
                    : .clear,
                    radius: 15,
                    x: 0,
                    y: 5
                )
            }
            .disabled(model.selectedRiskResult == nil)
            .buttonStyle(.plain)
            
            Button {
                Task {
                    await dismissImmersiveSpace()
                }
            } label: {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "xmark.circle.fill")
                    Text("Exit AR")
                        .font(DesignSystem.Typography.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.sm + 4)
                .background(.ultraThinMaterial)
                .foregroundStyle(.primary)
                .cornerRadius(DesignSystem.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("About")
                .font(DesignSystem.Typography.headline)
            Text("Shows a bedside Patient Card in mixed reality. Risk scores calculated from CSV data (HbA1c, BMI, medication timing). Fully on-device; no network calls.")
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .glassCard()
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            if let selectedPatient = model.selectedPatient {
                PatientCard(p: selectedPatient)
                    .transition(
                        DesignSystem.Animations.transition(
                            .scale.combined(with: .opacity),
                            .move(edge: .trailing)
                        )
                    )
            } else {
                VStack(spacing: DesignSystem.Spacing.md) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                    Text("Select a patient to preview")
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(.secondary)
                    Text("Choose from the list to see the patient card")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .glassCard()
            }
        }
        .animation(DesignSystem.Animations.spring, value: model.selectedPatient?.id)
    }
}

// MARK: - Patient Selection Card

struct PatientSelectionCard: View {
    let result: DiabetesRiskResult
    let isSelected: Bool
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Patient icon
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                
                // Patient info
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(result.patient.name)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(.primary)
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("Room \(result.patient.room)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Risk chip
                EnhancedRiskChip(band: result.patient.risk_band)
            }
            .padding(DesignSystem.Spacing.md)
            .background(
                isSelected
                ? Color.accentColor.opacity(0.15)
                : (isHovered ? Color.primary.opacity(0.05) : Color.clear)
            )
            .background(.ultraThinMaterial)
            .cornerRadius(DesignSystem.CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                    .strokeBorder(
                        isSelected
                        ? Color.accentColor.opacity(0.5)
                        : DesignSystem.Colors.glassBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(DesignSystem.Animations.quickSpring, value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
