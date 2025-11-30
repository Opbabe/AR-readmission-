import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var roomReady = false
    @Published var strapAdjusted = false
    @Published var lensesCleaned = false
    @Published var devModeOn = false
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


