import SwiftUI
import RealityKit
import ARKit

struct ImmersiveSceneView: View {
    @EnvironmentObject private var model: AppModel
    
    @State private var arSession = ARKitSession()
    @State private var worldTracking = WorldTrackingProvider()
    
    var body: some View {
        RealityView { content, attachments in
            let headAnchor = AnchorEntity(.head)
            
            // Patient Card - positioned ~60-70cm in front, slightly below eye line
            if let card = attachments.entity(for: "ARCard") {
                card.position = [0, -0.05, -0.6]
                headAnchor.addChild(card)
            }
            
            // Name Plate - positioned below the card
            if let plate = attachments.entity(for: "NamePlate") {
                plate.position = [0, -0.20, -0.6]
                headAnchor.addChild(plate)
            }
            
            // Stats Panel - positioned to the right like a monitor
            if let stats = attachments.entity(for: "StatsPanel") {
                stats.position = [0.45, -0.05, -0.7]
                headAnchor.addChild(stats)
            }
            
            content.add(headAnchor)
        } attachments: {
            let riskResult = model.selectedRiskResult
                ?? DiabetesRiskEngine.loadPatientsFromCSV().first!
            
            let p = riskResult.patient
            let f = riskResult.features
            
            // Patient Card Attachment
            Attachment(id: "ARCard") {
                PatientCard(p: p)
                    .frame(width: 560, height: 300)
                    .glassBackgroundEffect()
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            
            // Name Plate Attachment
            Attachment(id: "NamePlate") {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "person.fill")
                        .font(DesignSystem.Typography.callout)
                    Text("\(p.name) • Room \(p.room)")
                        .font(DesignSystem.Typography.callout)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm + 4)
                .background(.thinMaterial, in: .capsule)
                .overlay(
                    Capsule()
                        .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
                )
            }
            
            // Stats Panel Attachment
            Attachment(id: "StatsPanel") {
                DiabetesStatsView(features: f)
                    .frame(width: 420, height: 260)
                    .glassBackgroundEffect()
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
            }
        }
        .task {
            do {
                try await arSession.run([worldTracking])
                print("✅ ARKit session started successfully")
            } catch {
                print("❌ ARKitSession error: \(error.localizedDescription)")
            }
        }
    }
}
