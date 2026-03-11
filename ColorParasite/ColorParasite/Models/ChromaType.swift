//
//  ChromaType.swift
//  ColorParasite
//
//  Enumeration of game colors used throughout the parasite system.
//

import SpriteKit

enum ChromaType: Int, Codable, CaseIterable {
    case vermilion = 0
    case cerulean  = 1
    case viridian  = 2
    case aureolin  = 3
    case amethyst  = 4

    var pigment: SKColor {
        switch self {
        case .vermilion: return SKColor(red: 0.95, green: 0.30, blue: 0.30, alpha: 1.0)
        case .cerulean:  return SKColor(red: 0.25, green: 0.55, blue: 0.95, alpha: 1.0)
        case .viridian:  return SKColor(red: 0.20, green: 0.80, blue: 0.50, alpha: 1.0)
        case .aureolin:  return SKColor(red: 0.98, green: 0.78, blue: 0.20, alpha: 1.0)
        case .amethyst:  return SKColor(red: 0.65, green: 0.35, blue: 0.90, alpha: 1.0)
        }
    }

    var luminousPigment: SKColor {
        switch self {
        case .vermilion: return SKColor(red: 1.00, green: 0.50, blue: 0.50, alpha: 1.0)
        case .cerulean:  return SKColor(red: 0.50, green: 0.73, blue: 1.00, alpha: 1.0)
        case .viridian:  return SKColor(red: 0.45, green: 0.92, blue: 0.68, alpha: 1.0)
        case .aureolin:  return SKColor(red: 1.00, green: 0.88, blue: 0.45, alpha: 1.0)
        case .amethyst:  return SKColor(red: 0.80, green: 0.55, blue: 1.00, alpha: 1.0)
        }
    }

    var designation: String {
        switch self {
        case .vermilion: return "Red"
        case .cerulean:  return "Blue"
        case .viridian:  return "Green"
        case .aureolin:  return "Yellow"
        case .amethyst:  return "Purple"
        }
    }
}
