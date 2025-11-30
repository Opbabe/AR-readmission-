import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var appModel: AppModel
    @StateObject private var vm = OnboardingViewModel()
    @State private var showHow = false
    @State private var progressValue: Double = 0
    @State private var appear = false
    
    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                colors: [
                    Color.teal.opacity(0.08),
                    Color.blue.opacity(0.04),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xl) {
                    // Hero section
                    heroSection
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : -20)
                    
                    // Setup progress
                    progressIndicator
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .animation(DesignSystem.Animations.spring.delay(0.2), value: appear)
                    
                    // Fit checklist
                    FitChecklistView(
                        roomReady: $vm.roomReady,
                        strapAdjusted: $vm.strapAdjusted,
                        lensesCleaned: $vm.lensesCleaned,
                        devModeOn: $vm.devModeOn
                    )
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 20)
                    .animation(DesignSystem.Animations.spring.delay(0.3), value: appear)
                    
                    // Controls practice
                    ControlsPracticeView(practiced: $vm.practicedPinch)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .animation(DesignSystem.Animations.spring.delay(0.4), value: appear)
                    
                    // What you'll experience
                    experienceSection
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .animation(DesignSystem.Animations.spring.delay(0.5), value: appear)
                    
                    // Action buttons
                    actionButtons
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .animation(DesignSystem.Animations.spring.delay(0.6), value: appear)
                }
                .padding(DesignSystem.Spacing.xl)
            }
        }
        .sheet(isPresented: $showHow) {
            TutorialSheet()
        }
        .onChange(of: vm.roomReady) { _, _ in updateProgress() }
        .onChange(of: vm.strapAdjusted) { _, _ in updateProgress() }
        .onChange(of: vm.lensesCleaned) { _, _ in updateProgress() }
        .onChange(of: vm.devModeOn) { _, _ in updateProgress() }
        .onChange(of: vm.practicedPinch) { _, _ in updateProgress() }
        .onAppear {
            withAnimation(DesignSystem.Animations.spring) {
                appear = true
            }
            updateProgress()
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 30)
                
                Image(systemName: "stethoscope")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentColor, Color.teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.pulse, value: vm.canStart)
            }
            
            Text("Diabetes Risk Nurse")
                .font(DesignSystem.Typography.largeTitle)
                .foregroundStyle(.primary)
            
            Text("Glanceable diabetes risk and drivers at the bedside")
                .font(DesignSystem.Typography.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.lg)
            
            Text("Not for clinical use. Demo only.")
                .font(DesignSystem.Typography.caption2)
                .foregroundStyle(.secondary)
                .padding(.top, DesignSystem.Spacing.xs)
        }
        .padding(.top, DesignSystem.Spacing.xl)
    }
    
    // MARK: - Progress Indicator
    private var progressIndicator: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Setup Progress")
                    .font(DesignSystem.Typography.headline)
                Spacer()
                Text("\(Int(progressValue * 100))%")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                        .fill(.quaternary)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                        .fill(
                            LinearGradient(
                                colors: [Color.accentColor, Color.teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progressValue, height: 8)
                        .animation(DesignSystem.Animations.gentleSpring, value: progressValue)
                }
            }
            .frame(height: 8)
        }
        .glassCard()
    }
    
    // MARK: - Experience Section
    private var experienceSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "eye.fill")
                    .foregroundStyle(.accent)
                    .font(DesignSystem.Typography.title3)
                Text("What You'll Experience")
                    .font(DesignSystem.Typography.title3)
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                FeatureRow(
                    icon: "square.stack.3d.up.fill",
                    text: "Floating Patient Cards in mixed reality",
                    color: .accentColor
                )
                FeatureRow(
                    icon: "chart.bar.fill",
                    text: "Real-time risk assessment with color coding",
                    color: .teal
                )
                FeatureRow(
                    icon: "waveform.path.ecg",
                    text: "Key diabetes metrics at a glance",
                    color: .accentColor
                )
                FeatureRow(
                    icon: "list.bullet.clipboard.fill",
                    text: "Actionable care plans in plain language",
                    color: .teal
                )
            }
        }
        .glassCard()
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Button {
                withAnimation(DesignSystem.Animations.spring) {
                    appModel.hasCompletedOnboarding = true
                }
            } label: {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "play.fill")
                    Text("Begin Session")
                        .font(DesignSystem.Typography.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(
                    vm.canStart
                    ? LinearGradient(
                        colors: [Color.accentColor, Color.teal],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    : LinearGradient(
                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(DesignSystem.CornerRadius.medium)
                .shadow(
                    color: vm.canStart ? Color.accentColor.opacity(0.3) : .clear,
                    radius: 15,
                    x: 0,
                    y: 5
                )
            }
            .disabled(!vm.canStart)
            .buttonStyle(.plain)
            
            Button {
                showHow = true
            } label: {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Image(systemName: "questionmark.circle.fill")
                    Text("How It Works")
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
        .padding(.top, DesignSystem.Spacing.md)
    }
    
    // MARK: - Helpers
    private func updateProgress() {
        let completed = [
            vm.roomReady, vm.strapAdjusted, vm.lensesCleaned, vm.devModeOn, vm.practicedPinch
        ].filter { $0 }.count
        withAnimation(DesignSystem.Animations.gentleSpring) {
            progressValue = Double(completed) / 5.0
        }
    }
}

// MARK: - Supporting Views

private struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(DesignSystem.Typography.callout)
                .frame(width: 24, alignment: .leading)
            Text(text)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private struct TutorialSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Quick Start Guide")
                            .font(DesignSystem.Typography.largeTitle)
                        
                        Text("Learn how to use the Diabetes Risk Nurse app")
                            .font(DesignSystem.Typography.callout)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        TutorialStep(
                            number: "1",
                            title: "Launch & Setup",
                            description: "Complete the setup checklist to ensure your Vision Pro is ready for use."
                        )
                        
                        TutorialStep(
                            number: "2",
                            title: "Select Patient",
                            description: "Choose a patient from the list or search by name or room number."
                        )
                        
                        TutorialStep(
                            number: "3",
                            title: "Enter Mixed Reality",
                            description: "Tap 'Enter AR' to view the patient card floating in 3D space. The card stays comfortably positioned about 60-70cm in front of you."
                        )
                        
                        TutorialStep(
                            number: "4",
                            title: "Interact with Cards",
                            description: "Use gaze and pinch gestures to interact. All panels face you automatically for optimal readability."
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Controls")
                            .font(DesignSystem.Typography.headline)
                            .padding(.top, DesignSystem.Spacing.md)
                        
                        HStack(spacing: DesignSystem.Spacing.lg) {
                            ControlHint(icon: "eye.fill", label: "Gaze to aim")
                            ControlHint(icon: "hand.tap.fill", label: "Pinch to tap")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Privacy & Security")
                            .font(DesignSystem.Typography.headline)
                            .padding(.top, DesignSystem.Spacing.md)
                        
                        Text("All patient data is processed on-device. No network calls are made. PHI stays local and secure.")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .glassCard()
                }
                .padding(DesignSystem.Spacing.xl)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct TutorialStep: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            Text(number)
                .font(DesignSystem.Typography.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    LinearGradient(
                        colors: [Color.accentColor, Color.teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: .circle
                )
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.headline)
                Text(description)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct ControlHint: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(DesignSystem.Typography.title3)
                .foregroundStyle(.accent)
            Text(label)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.md)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
}
