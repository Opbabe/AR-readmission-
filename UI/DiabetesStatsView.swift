import SwiftUI
import Charts

struct DiabetesMetric: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let unit: String
    let color: Color
}

struct DiabetesStatsView: View {
    let features: DiabetesFeatures
    
    var metrics: [DiabetesMetric] {
        [
            .init(
                label: "HbA1c",
                value: features.hba1c,
                unit: "%",
                color: .red.opacity(0.8)
            ),
            .init(
                label: "BMI",
                value: features.bmi,
                unit: "",
                color: .orange.opacity(0.8)
            ),
            .init(
                label: "Last Med",
                value: features.lastMedHours,
                unit: "h",
                color: .blue.opacity(0.8)
            )
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            // Header
            headerSection
            
            // Metrics grid
            metricsGrid
            
            // Chart
            chartSection
            
            // Disclaimer
            disclaimer
        }
        .padding(DesignSystem.Spacing.lg)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: DesignSystem.CornerRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .strokeBorder(DesignSystem.Colors.glassBorder, lineWidth: 1)
        )
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: "chart.bar.fill")
                .foregroundStyle(.accent)
            Text("Diabetes Snapshot")
                .font(DesignSystem.Typography.headline)
        }
    }
    
    // MARK: - Metrics Grid
    private var metricsGrid: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.md) {
                MetricRow(
                    label: "Weight",
                    value: "\(Int(features.weightKg))",
                    unit: "kg",
                    icon: "scalemass.fill",
                    color: .blue
                )
                
                MetricRow(
                    label: "BMI",
                    value: String(format: "%.1f", features.bmi),
                    unit: "",
                    icon: "figure.stand",
                    color: .orange
                )
            }
            
            HStack(spacing: DesignSystem.Spacing.md) {
                MetricRow(
                    label: "HbA1c",
                    value: String(format: "%.1f", features.hba1c),
                    unit: "%",
                    icon: "heart.text.square.fill",
                    color: .red
                )
                
                MetricRow(
                    label: "Last Meds",
                    value: "\(Int(features.lastMedHours))",
                    unit: "h ago",
                    icon: "pills.fill",
                    color: .green
                )
            }
        }
    }
    
    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Key Metrics")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(.secondary)
            
            Chart(metrics) { metric in
                BarMark(
                    x: .value("Metric", metric.label),
                    y: .value("Value", metric.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [metric.color, metric.color.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(6)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                        .foregroundStyle(.secondary.opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                        .font(DesignSystem.Typography.caption2)
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                        .font(DesignSystem.Typography.caption2)
                }
            }
            .frame(height: 140)
        }
    }
    
    // MARK: - Disclaimer
    private var disclaimer: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("Demo only – not for clinical decisions.")
                .font(DesignSystem.Typography.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Metric Row Component

struct MetricRow: View {
    let label: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                    if !unit.isEmpty {
                        Text(unit)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.sm)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: DesignSystem.CornerRadius.small))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
}
