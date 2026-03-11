//
//  ShackleNode.swift
//  ColorParasite
//
//  Special orb that locks the player's next move to same-color only.
//

import SpriteKit

final class ShackleNode: CorpuscleNode {

    private let fetterRing: SKShapeNode

    override init(spec: CorpuscleSpec, radius: CGFloat) {
        // Dashed outer ring representing shackle
        let dashedPath = UIBezierPath(arcCenter: .zero, radius: radius + 6,
                                       startAngle: 0, endAngle: .pi * 2, clockwise: true)
        fetterRing = SKShapeNode(path: dashedPath.cgPath)
        fetterRing.strokeColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
        fetterRing.lineWidth = 2
        fetterRing.fillColor = .clear
        fetterRing.zPosition = 4

        let pattern: [CGFloat] = [4, 4]
        let dashedCGPath = dashedPath.cgPath.copy(dashingWithPhase: 0, lengths: pattern)
        fetterRing.path = dashedCGPath

        super.init(spec: spec, radius: radius)

        addChild(fetterRing)

        // Lock icon
        let lockGlyph = SKLabelNode(text: "🔒")
        lockGlyph.fontSize = radius * 0.7
        lockGlyph.verticalAlignmentMode = .center
        lockGlyph.horizontalAlignmentMode = .center
        lockGlyph.position = CGPoint(x: 0, y: radius + 12)
        lockGlyph.zPosition = 5
        addChild(lockGlyph)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initiateIdleKinesis() {
        super.initiateIdleKinesis()
        fetterRing.run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 8.0)
        ))
    }
}
