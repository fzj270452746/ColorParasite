//
//  LaurelGrade.swift
//  ColorParasite
//
//  Star rating system and player progress record.
//

import Foundation

enum LaurelGrade: Int, Codable, Comparable {
    case none   = 0
    case bronze = 1
    case silver = 2
    case gold   = 3

    static func < (lhs: LaurelGrade, rhs: LaurelGrade) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    var stellarCount: Int { return rawValue }
}

struct ChronicleRecord: Codable {
    var unlockedStratumIndex: Int
    var laurels: [String: LaurelGrade]

    var aggregateLaurels: Int {
        return laurels.values.reduce(0) { $0 + $1.stellarCount }
    }

    static func pristine() -> ChronicleRecord {
        return ChronicleRecord(unlockedStratumIndex: 1, laurels: [:])
    }

    func laurelForStratum(_ index: Int) -> LaurelGrade {
        return laurels["\(index)"] ?? .none
    }

    mutating func inscribeLaurel(_ grade: LaurelGrade, forStratum index: Int) {
        let existing = laurelForStratum(index)
        if grade > existing {
            laurels["\(index)"] = grade
        }
    }

    mutating func advanceUnlocked(to index: Int) {
        if index > unlockedStratumIndex {
            unlockedStratumIndex = index
        }
    }
}
