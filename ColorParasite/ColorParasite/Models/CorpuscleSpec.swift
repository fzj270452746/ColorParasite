//
//  CorpuscleSpec.swift
//  ColorParasite
//
//  Specification for a single orb entity within a level blueprint.
//

import CoreGraphics

enum CorpuscleVariant: String, Codable {
    case origin
    case standard
    case terminus
    case kaleidoscope
    case shackle
    case wormhole
    case nomadic
}

struct CorpuscleSpec: Codable {
    let identifier: String
    let variant: CorpuscleVariant
    let chroma: ChromaType?
    let latticePosition: CGPoint
    let wormholePartner: String?
    let nomadicWaypoints: [CGPoint]?

    init(
        identifier: String,
        variant: CorpuscleVariant,
        chroma: ChromaType? = nil,
        latticePosition: CGPoint,
        wormholePartner: String? = nil,
        nomadicWaypoints: [CGPoint]? = nil
    ) {
        self.identifier = identifier
        self.variant = variant
        self.chroma = chroma
        self.latticePosition = latticePosition
        self.wormholePartner = wormholePartner
        self.nomadicWaypoints = nomadicWaypoints
    }
}
