//
//  KinesisFactory.swift
//  ColorParasite
//
//  Reusable animation sequences for game entities.
//

import SpriteKit

enum KinesisFactory {

    // MARK: - Idle Animations

    static func perpetualPulse(amplitude: CGFloat = 1.08, period: TimeInterval = 1.2) -> SKAction {
        let expand = SKAction.scale(to: amplitude, duration: period / 2)
        expand.timingMode = .easeInEaseOut
        let contract = SKAction.scale(to: 1.0, duration: period / 2)
        contract.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([expand, contract]))
    }

    static func luminousFlicker(basePigment: SKColor, peakAlpha: CGFloat = 0.6, period: TimeInterval = 1.5) -> SKAction {
        let brighten = SKAction.fadeAlpha(to: peakAlpha, duration: period / 2)
        brighten.timingMode = .easeInEaseOut
        let dim = SKAction.fadeAlpha(to: 0.25, duration: period / 2)
        dim.timingMode = .easeInEaseOut
        return SKAction.repeatForever(SKAction.sequence([brighten, dim]))
    }

    // MARK: - Colonization Sequence

    static func colonizationTranslocation(from origin: CGPoint, to destination: CGPoint, duration: TimeInterval = 0.3) -> SKAction {
        let shrink = SKAction.scale(to: 0.6, duration: duration * 0.3)
        shrink.timingMode = .easeIn
        let traverse = SKAction.move(to: destination, duration: duration * 0.5)
        traverse.timingMode = .easeInEaseOut
        let expand = SKAction.scale(to: 1.0, duration: duration * 0.2)
        expand.timingMode = .easeOut
        return SKAction.sequence([shrink, traverse, expand])
    }

    // MARK: - Color Morphing

    static func chromaMorphSequence(to targetPigment: SKColor, duration: TimeInterval = 0.2) -> SKAction {
        return SKAction.colorize(with: targetPigment, colorBlendFactor: 1.0, duration: duration)
    }

    // MARK: - Corpuscle Consumed

    static func consumptionKinesis() -> SKAction {
        let pulse = SKAction.scale(to: 1.3, duration: 0.1)
        let fadeAndShrink = SKAction.group([
            SKAction.fadeAlpha(to: 0.3, duration: 0.25),
            SKAction.scale(to: 0.7, duration: 0.25)
        ])
        return SKAction.sequence([pulse, fadeAndShrink])
    }

    // MARK: - Triumph

    static func triumphantBurst() -> SKAction {
        let scale1 = SKAction.scale(to: 1.5, duration: 0.15)
        let scale2 = SKAction.scale(to: 0.8, duration: 0.1)
        let scale3 = SKAction.scale(to: 1.2, duration: 0.1)
        let scale4 = SKAction.scale(to: 1.0, duration: 0.1)
        return SKAction.sequence([scale1, scale2, scale3, scale4])
    }

    // MARK: - Wormhole Vortex

    static func perpetualVortex(period: TimeInterval = 2.0) -> SKAction {
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: period)
        return SKAction.repeatForever(rotate)
    }

    // MARK: - Shackle Rattle

    static func shackleVibration() -> SKAction {
        let left = SKAction.rotate(toAngle: -0.08, duration: 0.05)
        let right = SKAction.rotate(toAngle: 0.08, duration: 0.05)
        let center = SKAction.rotate(toAngle: 0, duration: 0.05)
        return SKAction.sequence([left, right, left, right, center])
    }

    // MARK: - Scene Entrance

    static func curtainRise(for node: SKNode, delay: TimeInterval = 0) -> SKAction {
        return SKAction.sequence([
            SKAction.wait(forDuration: delay),
            SKAction.group([
                SKAction.fadeAlpha(to: 1.0, duration: 0.35),
                SKAction.scale(to: 1.0, duration: 0.35)
            ])
        ])
    }

    // MARK: - Rejection Shake

    static func rejectionTremor() -> SKAction {
        let left = SKAction.moveBy(x: -6, y: 0, duration: 0.04)
        let right = SKAction.moveBy(x: 12, y: 0, duration: 0.04)
        let center = SKAction.moveBy(x: -6, y: 0, duration: 0.04)
        return SKAction.sequence([left, right, left, right, center])
    }

    // MARK: - Kaleidoscope Rainbow Cycle

    static func kaleidoscopeCycle(period: TimeInterval = 2.0) -> SKAction {
        let allChroma = ChromaType.allCases
        var actions: [SKAction] = []
        let stepDuration = period / Double(allChroma.count)
        for chroma in allChroma {
            actions.append(SKAction.colorize(with: chroma.pigment, colorBlendFactor: 1.0, duration: stepDuration))
        }
        return SKAction.repeatForever(SKAction.sequence(actions))
    }
}
