//
//  WormholeNode.swift
//  ColorParasite
//
//  Special orb that teleports the player to a paired wormhole.
//

import SpriteKit

final class WormholeNode: CorpuscleNode {

    private let vortexRing: SKShapeNode
    let partnerIdentifier: String?

    override init(spec: CorpuscleSpec, radius: CGFloat) {
        partnerIdentifier = spec.wormholePartner

        let spiralPath = UIBezierPath(arcCenter: .zero, radius: radius + 5,
                                       startAngle: 0, endAngle: .pi * 1.5, clockwise: true)
        vortexRing = SKShapeNode(path: spiralPath.cgPath)
        vortexRing.strokeColor = SKColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.7)
        vortexRing.lineWidth = 2.5
        vortexRing.fillColor = .clear
        vortexRing.zPosition = 4

        super.init(spec: spec, radius: radius)

        addChild(vortexRing)

        // Portal icon
        let portalGlyph = SKLabelNode(text: "⟲")
        portalGlyph.fontName = "AvenirNext-Bold"
        portalGlyph.fontSize = radius * 0.9
        portalGlyph.fontColor = SKColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.9)
        portalGlyph.verticalAlignmentMode = .center
        portalGlyph.horizontalAlignmentMode = .center
        portalGlyph.zPosition = 3
        addChild(portalGlyph)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initiateIdleKinesis() {
        super.initiateIdleKinesis()
        vortexRing.run(KinesisFactory.perpetualVortex(period: 3.0))
    }
}
