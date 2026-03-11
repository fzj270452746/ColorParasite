//
//  KaleidoscopeNode.swift
//  ColorParasite
//
//  Special orb that randomly changes the player's color upon colonization.
//

import SpriteKit

final class KaleidoscopeNode: CorpuscleNode {

    private let enigmaGlyph: SKLabelNode

    override init(spec: CorpuscleSpec, radius: CGFloat) {
        enigmaGlyph = SKLabelNode(text: "?")
        enigmaGlyph.fontName = "AvenirNext-Bold"
        enigmaGlyph.fontSize = radius * 1.1
        enigmaGlyph.fontColor = SKColor.white.withAlphaComponent(0.9)
        enigmaGlyph.verticalAlignmentMode = .center
        enigmaGlyph.horizontalAlignmentMode = .center
        enigmaGlyph.zPosition = 3

        super.init(spec: spec, radius: radius)

        addChild(enigmaGlyph)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configurePigmentation() {
        nucleus.fillColor = ChromaType.vermilion.pigment
        halo.strokeColor = ChromaType.aureolin.luminousPigment.withAlphaComponent(0.6)
    }

    override func initiateIdleKinesis() {
        super.initiateIdleKinesis()
        // Cycle through colors
        let allChroma = ChromaType.allCases
        var colorActions: [SKAction] = []
        for chroma in allChroma {
            let changeColor = SKAction.run { [weak self] in
                self?.nucleus.fillColor = chroma.pigment
            }
            colorActions.append(changeColor)
            colorActions.append(SKAction.wait(forDuration: 0.5))
        }
        nucleus.run(SKAction.repeatForever(SKAction.sequence(colorActions)))
    }

    func resolveRandomChroma() -> ChromaType {
        return ChromaType.allCases.randomElement()!
    }
}
