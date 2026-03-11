//
//  CorpuscleNode.swift
//  ColorParasite
//
//  Base class for all orb entities in the game arena.
//

import SpriteKit

class CorpuscleNode: SKNode {

    let spec: CorpuscleSpec
    let nucleus: SKShapeNode
    let halo: SKShapeNode
    var isColonized: Bool = false
    var orbRadius: CGFloat

    init(spec: CorpuscleSpec, radius: CGFloat) {
        self.spec = spec
        self.orbRadius = radius

        nucleus = SKShapeNode(circleOfRadius: radius)
        nucleus.lineWidth = 0
        nucleus.strokeColor = .clear

        halo = SKShapeNode(circleOfRadius: radius + 3)
        halo.lineWidth = 2.5
        halo.fillColor = .clear

        super.init()

        self.name = spec.identifier
        addChild(halo)
        addChild(nucleus)

        configurePigmentation()
        initiateIdleKinesis()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePigmentation() {
        guard let chroma = spec.chroma else {
            nucleus.fillColor = ChromaPalette.terminusIvory
            halo.strokeColor = SKColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 0.8)
            return
        }
        nucleus.fillColor = chroma.pigment
        halo.strokeColor = chroma.luminousPigment.withAlphaComponent(0.5)
    }

    func initiateIdleKinesis() {
        halo.run(KinesisFactory.luminousFlicker(
            basePigment: halo.strokeColor,
            peakAlpha: 0.6,
            period: 1.5 + Double.random(in: -0.3...0.3)
        ))
    }

    func executeColonizationKinesis(completion: @escaping () -> Void) {
        isColonized = true
        halo.removeAllActions()
        let kinesis = KinesisFactory.consumptionKinesis()
        self.run(kinesis) {
            completion()
        }
    }

    func hitTestEnvelope(at point: CGPoint) -> Bool {
        let expandedRadius = orbRadius * 1.5
        let dx = point.x - position.x
        let dy = point.y - position.y
        return (dx * dx + dy * dy) <= (expandedRadius * expandedRadius)
    }

    func resetToVirginState() {
        isColonized = false
        self.alpha = 1.0
        self.setScale(1.0)
        halo.removeAllActions()
        initiateIdleKinesis()
    }
}
