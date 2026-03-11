//
//  NomadicNode.swift
//  ColorParasite
//
//  Special orb that moves along a predefined path periodically.
//

import SpriteKit

final class NomadicNode: CorpuscleNode {

    private var waypoints: [CGPoint] = []
    private var trailNode: SKShapeNode?
    var sceneMagnitude: CGSize = .zero
    var gridSpec: (columns: Int, rows: Int) = (1, 1)

    func configureNomadicBehavior(
        sceneMagnitude: CGSize,
        gridSpec: (columns: Int, rows: Int),
        safeAreaPadding: UIEdgeInsets = .zero
    ) {
        self.sceneMagnitude = sceneMagnitude
        self.gridSpec = gridSpec

        guard let specWaypoints = spec.nomadicWaypoints, !specWaypoints.isEmpty else { return }

        waypoints = specWaypoints.map { latticePoint in
            ViewportCalibrator.sceneCoordinate(
                latticePoint: latticePoint,
                gridSpec: gridSpec,
                sceneMagnitude: sceneMagnitude,
                safeAreaPadding: safeAreaPadding
            )
        }

        commenceWandering()
    }

    private func commenceWandering() {
        guard waypoints.count > 1 else { return }

        var moveActions: [SKAction] = []
        for waypoint in waypoints {
            let moveAction = SKAction.move(to: waypoint, duration: 1.5)
            moveAction.timingMode = .easeInEaseOut
            moveActions.append(moveAction)
            moveActions.append(SKAction.wait(forDuration: 0.5))
        }
        // Return to origin
        let returnAction = SKAction.move(to: position, duration: 1.5)
        returnAction.timingMode = .easeInEaseOut
        moveActions.append(returnAction)
        moveActions.append(SKAction.wait(forDuration: 0.5))

        run(SKAction.repeatForever(SKAction.sequence(moveActions)), withKey: "nomadic_wander")
    }

    func haltWandering() {
        removeAction(forKey: "nomadic_wander")
    }

    override func configurePigmentation() {
        super.configurePigmentation()

        // Add motion indicator arrows
        let arrowGlyph = SKLabelNode(text: "↔")
        arrowGlyph.fontName = "AvenirNext-Medium"
        arrowGlyph.fontSize = orbRadius * 0.7
        arrowGlyph.fontColor = SKColor.white.withAlphaComponent(0.6)
        arrowGlyph.verticalAlignmentMode = .center
        arrowGlyph.horizontalAlignmentMode = .center
        arrowGlyph.position = CGPoint(x: 0, y: -orbRadius - 10)
        arrowGlyph.zPosition = 3
        addChild(arrowGlyph)
    }
}
