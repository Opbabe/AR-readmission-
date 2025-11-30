import SwiftUI
import Combine

final class AppModel: ObservableObject {
    // App flow
    @Published var hasCompletedOnboarding = false

    // Patient selection - now using DiabetesRiskResult
    @Published var riskResults: [DiabetesRiskResult] = []
    @Published var selectedRiskResult: DiabetesRiskResult? = nil
    
    var patients: [Patient] {
        riskResults.map { $0.patient }
    }
    
    var selectedPatient: Patient? {
        selectedRiskResult?.patient
    }

    // Immersive ID
    let immersiveSpaceID = "ImmersiveSpace"
    
    init() {
        loadPatients()
    }
    
    private func loadPatients() {
        riskResults = DiabetesRiskEngine.loadPatientsFromCSV()
        if selectedRiskResult == nil, let first = riskResults.first {
            selectedRiskResult = first
        }
    }

    // Helpers
    func select(patient: Patient) {
        selectedRiskResult = riskResults.first(where: { $0.patient.id == patient.id })
    }
    
    func select(riskResult: DiabetesRiskResult) {
        selectedRiskResult = riskResult
    }

    func selectBy(name: String, room: String) -> Bool {
        if let result = riskResults.first(where: {
            $0.patient.name.caseInsensitiveCompare(name) == .orderedSame && $0.patient.room == room
        }) {
            selectedRiskResult = result
            return true
        }
        return false
    }
}



