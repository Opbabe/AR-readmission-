import SwiftUI

final class OnboardingViewModel: ObservableObject {
    // Setup checklist
    @Published var roomReady = false
    @Published var strapAdjusted = false
    @Published var lensesCleaned = false
    @Published var devModeOn = false

    // Controls practice (tap == pinch)
    @Published var practicedPinch = false

    var canStart: Bool {
        roomReady && strapAdjusted && lensesCleaned && devModeOn && practicedPinch
    }

    func reset() {
        roomReady = false
        strapAdjusted = false
        lensesCleaned = false
        devModeOn = false
        practicedPinch = false
    }
}


