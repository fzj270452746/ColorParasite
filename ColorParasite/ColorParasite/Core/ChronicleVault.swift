//
//  ChronicleVault.swift
//  ColorParasite
//
//  Persistent storage for player progress using UserDefaults.
//

import Foundation

final class ChronicleVault {

    static let shared = ChronicleVault()

    private let repositoryKey = "symbiosis_chronicle_v1"

    private init() {}

    func excavate() -> ChronicleRecord {
        guard let datum = UserDefaults.standard.data(forKey: repositoryKey),
              let record = try? JSONDecoder().decode(ChronicleRecord.self, from: datum)
        else {
            return ChronicleRecord.pristine()
        }
        return record
    }

    func enshrine(_ record: ChronicleRecord) {
        if let datum = try? JSONEncoder().encode(record) {
            UserDefaults.standard.set(datum, forKey: repositoryKey)
        }
    }

    func inscribeLaurel(_ grade: LaurelGrade, forStratum index: Int) {
        var record = excavate()
        record.inscribeLaurel(grade, forStratum: index)
        enshrine(record)
    }

    func advanceUnlocked(to index: Int) {
        var record = excavate()
        record.advanceUnlocked(to: index)
        enshrine(record)
    }

    func purgeAllRecords() {
        UserDefaults.standard.removeObject(forKey: repositoryKey)
    }
}
