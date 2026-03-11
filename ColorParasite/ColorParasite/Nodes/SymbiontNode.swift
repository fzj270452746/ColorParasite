//
//  SymbiontNode.swift
//  ColorParasite
//
//  The player-controlled parasite ball that colonizes host orbs.
//

import SpriteKit

final class SymbiontNode: SKNode {

    private(set) var currentChroma: ChromaType
    let corona: SKShapeNode
    let core: SKShapeNode
    private let glowEmitter: SKShapeNode
    var entityRadius: CGFloat

    init(initialChroma: ChromaType, radius: CGFloat) {
        self.currentChroma = initialChroma
        self.entityRadius = radius

        let enlargedRadius = radius * 1.25

        core = SKShapeNode(circleOfRadius: enlargedRadius)
        core.fillColor = initialChroma.pigment
        core.strokeColor = .clear
        core.lineWidth = 0
        core.zPosition = 2

        corona = SKShapeNode(circleOfRadius: enlargedRadius + 4)
        corona.fillColor = .clear
        corona.strokeColor = initialChroma.luminousPigment.withAlphaComponent(0.6)
        corona.lineWidth = 3
        corona.zPosition = 1

        glowEmitter = SKShapeNode(circleOfRadius: enlargedRadius + 8)
        glowEmitter.fillColor = initialChroma.luminousPigment.withAlphaComponent(0.15)
        glowEmitter.strokeColor = .clear
        glowEmitter.lineWidth = 0
        glowEmitter.zPosition = 0

        super.init()

        self.zPosition = 10
        addChild(glowEmitter)
        addChild(corona)
        addChild(core)

        commenceAmbientKinesis()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Visual Updates

    func morphChroma(to newChroma: ChromaType, duration: TimeInterval = 0.2) {
        currentChroma = newChroma

        let colorAction = SKAction.customAction(withDuration: duration) { [weak self] _, elapsed in
            guard let self = self else { return }
            let progress = elapsed / CGFloat(duration)
            if progress >= 1.0 {
                self.core.fillColor = newChroma.pigment
                self.corona.strokeColor = newChroma.luminousPigment.withAlphaComponent(0.6)
                self.glowEmitter.fillColor = newChroma.luminousPigment.withAlphaComponent(0.15)
            }
        }

        let finalSet = SKAction.run { [weak self] in
            self?.core.fillColor = newChroma.pigment
            self?.corona.strokeColor = newChroma.luminousPigment.withAlphaComponent(0.6)
            self?.glowEmitter.fillColor = newChroma.luminousPigment.withAlphaComponent(0.15)
        }

        run(SKAction.sequence([colorAction, finalSet]))
    }

    func translocate(to destination: CGPoint, duration: TimeInterval = 0.35, completion: @escaping () -> Void) {
        let kinesis = KinesisFactory.colonizationTranslocation(
            from: position,
            to: destination,
            duration: duration
        )
        run(kinesis) {
            completion()
        }
    }

    // MARK: - Ambient Kinesis

    private func commenceAmbientKinesis() {
        corona.run(KinesisFactory.perpetualPulse(amplitude: 1.1, period: 1.4))
        glowEmitter.run(KinesisFactory.luminousFlicker(
            basePigment: currentChroma.luminousPigment,
            peakAlpha: 0.2,
            period: 1.6
        ))
    }
}
