import SwiftUI

struct FitChecklistView: View {
    @Binding var roomReady: Bool
    @Binding var strapAdjusted: Bool
    @Binding var lensesCleaned: Bool
    @Binding var devModeOn: Bool

    // Explicit initializer to ensure accessibility from other files in the module
    init(roomReady: Binding<Bool>, strapAdjusted: Binding<Bool>, lensesCleaned: Binding<Bool>, devModeOn: Binding<Bool>) {
        self._roomReady = roomReady
        self._strapAdjusted = strapAdjusted
        self._lensesCleaned = lensesCleaned
        self._devModeOn = devModeOn
    }
    
    private var redTheme = Color(red: 0.85, green: 0.15, blue: 0.2)
    private var redAccent = Color(red: 1.0, green: 0.3, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checklist")
                    .foregroundStyle(redAccent)
                    .font(.title3)
                Text("Fit & Setup")
                    .font(.title3)
                    .bold()
            }
            
            ChecklistItem(
                isChecked: $roomReady,
                icon: "light.max",
                title: "Room ready",
                subtitle: "Normal lighting, clear desk/bedside",
                description: "Avoid strong backlight; keep hands visible.",
                color: redTheme
            )
            
            ChecklistItem(
                isChecked: $strapAdjusted,
                icon: "person.fill.checkmark",
                title: "Strap adjusted",
                subtitle: "Comfortable, stable fit",
                color: redTheme
            )
            
            ChecklistItem(
                isChecked: $lensesCleaned,
                icon: "eye.fill",
                title: "Lenses cleaned",
                subtitle: "No smudges or marks",
                color: redTheme
            )
            
            ChecklistItem(
                isChecked: $devModeOn,
                icon: "gear.circle.fill",
                title: "Developer Mode ON",
                subtitle: "Required for AR features",
                description: "Vision Pro: Settings → Privacy & Security → Developer Mode",
                color: redTheme
            )
        }
        .padding(20)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(redTheme.opacity(0.3), lineWidth: 2))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

private struct ChecklistItem: View {
    @Binding var isChecked: Bool
    let icon: String
    let title: String
    let subtitle: String
    var description: String? = nil
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(color.opacity(isChecked ? 0.2 : 0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundStyle(isChecked ? color : Color.gray)
                    .font(.body)
                    .symbolEffect(.bounce, value: isChecked)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(isChecked ? .primary : .secondary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let desc = description {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.8))
                        .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Custom toggle style
            Toggle("", isOn: $isChecked)
                .toggleStyle(.switch)
                .tint(color)
        }
        .padding(.vertical, 8)
    }
}
