import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var appModel: AppModel
    @StateObject private var vm = OnboardingViewModel()
    @State private var showHow = false

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 8) {
                    Text("🩺 ARadmission")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                    Text("Help nurses/doctors quickly see who’s likely to return — and why.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Card {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What you’ll see").font(.headline)
                        Text("A floating Patient Card in mixed reality: risk color (🟢🟡🔴), top reasons, and a short plan.")
                            .foregroundStyle(.secondary)
                    }
                }

                FitChecklistView(
                    roomReady: $vm.roomReady,
                    strapAdjusted: $vm.strapAdjusted,
                    lensesCleaned: $vm.lensesCleaned,
                    devModeOn: $vm.devModeOn
                )

                ControlsPracticeView(practiced: $vm.practicedPinch)

                HStack(spacing: 12) {
                    Button("Start") {
                        appModel.hasCompletedOnboarding = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!vm.canStart)
                    .help(vm.canStart ? "Start the demo" : "Complete setup and practice first")

                    Button("How it works") { showHow = true }
                        .buttonStyle(.bordered)

                    Button("Reset") { vm.reset() }
                        .buttonStyle(.bordered)
                }
            }
            .padding(28)
            .background(
                LinearGradient(colors: [.teal.opacity(0.08), .clear],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
        }
        .sheet(isPresented: $showHow) { TutorialSheet() }
    }
}

private struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { content }
            .padding(16)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))
    }
}

private struct TutorialSheet: View {
    @Environment(.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 18) {
            Text("Quick Tutorial").font(.title2).bold()
            VStack(alignment: .leading, spacing: 8) {
                Text("• Launch: open app → Start → choose patient → Enter AR")
                Text("• Controls: gaze to aim; pinch to tap; long-press = details")
                Text("• Comfort: card sits ~60–70 cm away and faces you for readability")
                Text("• Privacy: demo uses on-device synthetic patients; no network")
            }
            .foregroundStyle(.secondary)
            Button("Got it") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .presentationDetents([.height(300)])
    }
}


