import SwiftUI

@main
struct ARadmissionApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
        }
        .defaultSize(width: 980, height: 640)

        // Mixed = see-through immersive space (works in Simulator)
        ImmersiveSpace(id: model.immersiveSpaceID) {
            ImmersiveSceneView()
                .environmentObject(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}


