//
//  VesicleNode.swift
//  ColorParasite
//
//  Standard host orb that the player can parasitize.
//

import SpriteKit

final class VesicleNode: CorpuscleNode {

    override func configurePigmentation() {
        super.configurePigmentation()

        // Add inner highlight for depth
        let highlightRadius = orbRadius * 0.45
        let highlight = SKShapeNode(circleOfRadius: highlightRadius)
        highlight.fillColor = SKColor.white.withAlphaComponent(0.3)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: -orbRadius * 0.2, y: orbRadius * 0.2)
        highlight.zPosition = 1
        nucleus.addChild(highlight)
    }
}
