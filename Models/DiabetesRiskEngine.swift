import Foundation

struct DiabetesFeatures {
    let patientID: String
    let name: String
    let room: String
    let weightKg: Double
    let bmi: Double
    let hba1c: Double
    let lastMedHours: Double
}

enum RiskBand: String {
    case low = "Low"
    case medium = "Med"
    case high = "High"
}

struct DiabetesRiskResult: Identifiable {
    let patient: Patient          // your existing type
    let features: DiabetesFeatures
    
    var id: String { patient.id }
}

enum DiabetesRiskEngine {
    
    // MARK: - Public API
    
    static func loadPatientsFromCSV() -> [DiabetesRiskResult] {
        guard let url = Bundle.main.url(forResource: "diabetes_demo", withExtension: "csv") else {
            print("⚠️ Warning: diabetes_demo.csv not found in bundle. Using fallback demo data.")
            // Fallback to your existing demo patients if CSV missing
            return Patient.demoPatients.map { p in
                let fakeFeatures = DiabetesFeatures(
                    patientID: p.patient_id,
                    name: p.name,
                    room: p.room,
                    weightKg: 80,
                    bmi: 30,
                    hba1c: 8.0,
                    lastMedHours: 24
                )
                return DiabetesRiskResult(patient: p, features: fakeFeatures)
            }
        }
        
        guard let data = try? String(contentsOf: url) else {
            print("⚠️ Warning: Could not read diabetes_demo.csv. Using fallback demo data.")
            return Patient.demoPatients.map { p in
                let fakeFeatures = DiabetesFeatures(
                    patientID: p.patient_id,
                    name: p.name,
                    room: p.room,
                    weightKg: 80,
                    bmi: 30,
                    hba1c: 8.0,
                    lastMedHours: 24
                )
                return DiabetesRiskResult(patient: p, features: fakeFeatures)
            }
        }
        
        //Simple CSV test
        
        
        let rows = data
            .split(separator: "\n")
            .dropFirst() // skip header
            .map { line -> DiabetesFeatures? in
                // Simple CSV parsing - split by comma and trim whitespace
                let cols = line.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                guard cols.count >= 7,
                      let weight = Double(cols[3]),
                      let bmi = Double(cols[4]),
                      let hba1c = Double(cols[5]),
                      let last = Double(cols[6]) else {
                    print("⚠️ Warning: Could not parse CSV row: \(line)")
                    return nil
                }
                
                return DiabetesFeatures(
                    patientID: cols[0],
                    name: cols[1],
                    room: cols[2],
                    weightKg: weight,
                    bmi: bmi,
                    hba1c: hba1c,
                    lastMedHours: last
                )
            }
            .compactMap { $0 }
        
        if rows.isEmpty {
            print("⚠️ Warning: No valid rows parsed from CSV. Using fallback demo data.")
            return Patient.demoPatients.map { p in
                let fakeFeatures = DiabetesFeatures(
                    patientID: p.patient_id,
                    name: p.name,
                    room: p.room,
                    weightKg: 80,
                    bmi: 30,
                    hba1c: 8.0,
                    lastMedHours: 24
                )
                return DiabetesRiskResult(patient: p, features: fakeFeatures)
            }
        }
        
        return rows.map { features in
            let (score, band, drivers, alerts, plan) = score(features: features)
            
            let patient = Patient(
                patient_id: features.patientID,
                name: features.name,
                room: features.room,
                risk_score: score,
                risk_band: band.rawValue,
                drivers: drivers,
                alerts: alerts,
                teachback_plan: plan
            )
            
            return DiabetesRiskResult(patient: patient, features: features)
        }
    }
    
    // MARK: - Toy risk model (demo only)
    
    private static func score(features: DiabetesFeatures)
    -> (Double, RiskBand, [String], [String], String) {
        
        var points = 0
        var drivers: [String] = []
        var alerts: [String] = []
        
        // Totally made-up logic for demo purposes only:
        if features.hba1c >= 9 {
            points += 4
            drivers.append("HbA1c very high (\(features.hba1c))")
        } else if features.hba1c >= 7.5 {
            points += 3
            drivers.append("HbA1c elevated (\(features.hba1c))")
        } else if features.hba1c >= 7.0 {
            points += 2
            drivers.append("HbA1c borderline (\(features.hba1c))")
        }
        
        if features.bmi >= 35 {
            points += 3
            drivers.append("BMI ≥ 35")
        } else if features.bmi >= 30 {
            points += 2
            drivers.append("BMI ≥ 30")
        }
        
        if features.lastMedHours >= 36 {
            points += 3
            drivers.append("Long time since meds (\(Int(features.lastMedHours))h)")
        } else if features.lastMedHours >= 24 {
            points += 2
            drivers.append("Meds > 24h ago")
        }
        
        if features.weightKg >= 90 {
            points += 1
            drivers.append("Higher body weight")
        }
        
        // Convert points → 0–1 score
        let maxPoints = 12.0
        let score = min(Double(points) / maxPoints, 1.0)
        
        let band: RiskBand
        if score >= 0.7 {
            band = .high
        } else if score >= 0.4 {
            band = .medium
        } else {
            band = .low
        }
        
        switch band {
        case .high:
            alerts.append("High readmission risk (demo)")
        case .medium:
            alerts.append("Moderate readmission risk (demo)")
        case .low:
            break
        }
        
        let plan: String
        switch band {
        case .high:
            plan = "Follow-up ≤ 7 days; meds reconciliation; diabetes teach-back."
        case .medium:
            plan = "Clinic call in 3–5 days; glucose log review; reinforce meds."
        case .low:
            plan = "Standard follow-up; diet + activity handouts; PCP in 2–3 weeks."
        }
        
        return (score, band, drivers, alerts, plan)
    }
}

