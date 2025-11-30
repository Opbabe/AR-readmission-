import SwiftUI

struct ControlsPracticeView: View {
    @Binding var practiced: Bool
    @State private var hits = 0
    @State private var pulseScale: CGFloat = 1.0
    
    // Explicit initializer for accessibility
    init(practiced: Binding<Bool>) {
        self._practiced = practiced
    }
    
    private var redTheme = Color(red: 0.85, green: 0.15, blue: 0.2)
    private var redAccent = Color(red: 1.0, green: 0.3, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(redAccent)
                    .font(.title3)
                Text("Controls Practice")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                if practiced {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(redAccent)
                        Text("Ready")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(redTheme)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(redAccent.opacity(0.15), in: .capsule)
                }
            }

            Text("Look to aim (gaze) • Pinch thumb + index to tap")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    hits += 1
                    if hits >= 1 {
                        practiced = true
                        pulseScale = 1.15
                    } else {
                        pulseScale = 1.05
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        pulseScale = 1.0
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            practiced
                                ? LinearGradient(
                                    colors: [redAccent.opacity(0.3), redTheme.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    practiced ? redAccent.opacity(0.5) : Color.white.opacity(0.12),
                                    lineWidth: practiced ? 2 : 1
                                )
                        )
                    
                    HStack(spacing: 12) {
                        if practiced {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(redAccent)
                        } else {
                            Image(systemName: "hand.point.up.left.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(practiced ? "Excellent! Pinch recognized" : "Tap here to try a pinch")
                                .font(.headline)
                                .foregroundStyle(practiced ? redTheme : .primary)
                            
                            if !practiced {
                                Text("Look at the button, then pinch")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .scaleEffect(pulseScale)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .accessibilityLabel("Practice pinch target")
        }
        .padding(20)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(redTheme.opacity(0.3), lineWidth: 2))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}


