import SwiftUI

struct ControlsPracticeView: View {
    @Binding var practiced: Bool
    @State private var hits = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Controls practice").font(.headline)
                if practiced {
                    Spacer()
                    Label("Ready", systemImage: "checkmark.seal.fill").foregroundStyle(.green)
                }
            }

            Text("Look to aim (gaze). Pinch thumb + index = tap.")
                .foregroundStyle(.secondary)

            Button {
                hits += 1
                if hits >= 1 { practiced = true }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.thinMaterial)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12)))
                    Text(practiced ? "Nice! Pinch recognized" : "Tap here to try a pinch")
                        .font(.headline)
                }
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .accessibilityLabel("Practice pinch target")
        }
        .padding(16)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))
    }
}


