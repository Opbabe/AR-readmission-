import Foundation

struct Patient: Identifiable, Codable, Equatable {
    var id: String { patient_id }

    let patient_id: String
    let name: String
    let room: String

    let risk_score: Double         // 0..1
    let risk_band: String          // "Low" | "Med" | "High"
    let drivers: [String]          // key reasons
    let alerts: [String]           // extra flags
    let teachback_plan: String     // short plan
}

extension Patient {
    static let demoPatients: [Patient] = [
        .init(patient_id: "p001", name: "Ana Gomez",  room: "4A-12",
              risk_score: 0.78, risk_band: "High",
              drivers: ["HbA1c uncontrolled", "LOS > 7 days", "Polypharmacy"],
              alerts: ["Recent transfer", "10+ medications"],
              teachback_plan: "Follow-up in 7 days; medication reconciliation; insulin teach-back."),
        .init(patient_id: "p002", name: "James Lin",  room: "3B-05",
              risk_score: 0.42, risk_band: "Med",
              drivers: ["CKD stage 3", "History of hypoglycemia"],
              alerts: ["Recent sepsis"],
              teachback_plan: "Call clinic in 3 days; CGM refresher; renal dose check."),
        .init(patient_id: "p003", name: "Maya Patel", room: "2C-09",
              risk_score: 0.21, risk_band: "Low",
              drivers: ["New diagnosis", "Short LOS"],
              alerts: [],
              teachback_plan: "Pharmacist call in 48h; dietitian handout; PCP in 2 weeks."),
        .init(patient_id: "p004", name: "Luis Rivera", room: "5D-02",
              risk_score: 0.63, risk_band: "Med",
              drivers: ["Multiple ER visits", "A1c trend rising"],
              alerts: ["Missed insulin doses"],
              teachback_plan: "Nurse call in 72h; insulin pen demo; transport support.")
    ]
}



