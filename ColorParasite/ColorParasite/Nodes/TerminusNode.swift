//
//  TerminusNode.swift
//  ColorParasite
//
//  The goal orb that completes the level when reached.
//

import SpriteKit

final class TerminusNode: CorpuscleNode {

    private let targetSprite: SKSpriteNode

    override init(spec: CorpuscleSpec, radius: CGFloat) {
        let texture = SKTexture(imageNamed: "target")
        targetSprite = SKSpriteNode(texture: texture)
        targetSprite.size = CGSize(width: radius * 1.2, height: radius * 1.2)
        targetSprite.alpha = 0.85
        targetSprite.zPosition = 3

        super.init(spec: spec, radius: radius)

        addChild(targetSprite)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configurePigmentation() {
        nucleus.fillColor = ChromaPalette.terminusIvory
        halo.strokeColor = SKColor(red: 0.85, green: 0.78, blue: 0.55, alpha: 0.6)
        halo.lineWidth = 2.5

        // Subtle radial gradient effect
        let innerGlow = SKShapeNode(circleOfRadius: orbRadius * 0.7)
        innerGlow.fillColor = SKColor.white.withAlphaComponent(0.5)
        innerGlow.strokeColor = .clear
        innerGlow.zPosition = 1
        nucleus.addChild(innerGlow)
    }

    override func initiateIdleKinesis() {
        super.initiateIdleKinesis()
        targetSprite.run(KinesisFactory.perpetualPulse(amplitude: 1.15, period: 1.8))
    }
}
