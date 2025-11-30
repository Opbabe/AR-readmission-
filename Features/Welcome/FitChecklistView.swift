import SwiftUI

struct FitChecklistView: View {
    @Binding var roomReady: Bool
    @Binding var strapAdjusted: Bool
    @Binding var lensesCleaned: Bool
    @Binding var devModeOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fit & Setup").font(.headline)

            Toggle(isOn: $roomReady) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Room ready (normal lighting, clear desk/bedside)")
                    Text("Avoid strong backlight; keep hands visible.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }

            Toggle(isOn: $strapAdjusted) {
                Text("Strap adjusted (comfortable, stable)")
            }

            Toggle(isOn: $lensesCleaned) {
                Text("Lenses cleaned (no smudges)")
            }

            Toggle(isOn: $devModeOn) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Developer Mode ON")
                    Text("Vision Pro: Settings → Privacy & Security → Developer Mode")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))
    }
}


