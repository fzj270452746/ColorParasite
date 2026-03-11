//
//  StratumBlueprint.swift
//  ColorParasite
//
//  Data model representing a complete level configuration.
//

import CoreGraphics

enum StratumTier: String, Codable {
    case neophyte  = "Beginner"
    case adept     = "Intermediate"
    case arduous   = "Hard"
    case crucible  = "Challenge"
}

struct StratumBlueprint: Codable {
    let stratumIndex: Int
    let tier: StratumTier
    let title: String
    let latticeColumns: Int
    let latticeRows: Int
    let originIdentifier: String
    let terminusIdentifier: String
    let initialChroma: ChromaType
    let corpuscles: [CorpuscleSpec]
    let optimalCadence: Int
    let maxCadence: Int
}
