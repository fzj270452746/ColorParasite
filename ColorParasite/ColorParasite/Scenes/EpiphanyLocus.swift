//
//  EpiphanyLocus.swift
//  ColorParasite
//
//  Level completion celebration scene with star rating and navigation.
//

import SpriteKit

final class EpiphanyLocus: SKScene {

    var stratumIndex: Int = 1
    var awardedLaurel: LaurelGrade = .bronze
    var cadenceExpended: Int = 0

    private var backdrop: GradientBackdrop!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        assembleBackdrop()
        assembleCelebration()
        assembleNavigationSigils()
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.EpiphanyGradient.zenith,
            nadirPigment: ChromaPalette.EpiphanyGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleCelebration() {
        let factor = ViewportCalibrator.proportionFactor(for: size)

        // "Level Complete" header
        let completeLabel = SKLabelNode(text: "Level Complete!")
        completeLabel.fontName = "AvenirNext-Bold"
        completeLabel.fontSize = 30 * factor
        completeLabel.fontColor = .white
        completeLabel.horizontalAlignmentMode = .center
        completeLabel.verticalAlignmentMode = .center
        completeLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.72)
        completeLabel.alpha = 0
        completeLabel.setScale(0.5)
        addChild(completeLabel)
        completeLabel.run(KinesisFactory.curtainRise(for: completeLabel, delay: 0.1))

        // Level number
        let levelLabel = SKLabelNode(text: "Level \(stratumIndex)")
        levelLabel.fontName = "AvenirNext-DemiBold"
        levelLabel.fontSize = 18 * factor
        levelLabel.fontColor = SKColor.white.withAlphaComponent(0.85)
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.verticalAlignmentMode = .center
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.72 - 40 * factor)
        levelLabel.alpha = 0
        addChild(levelLabel)
        levelLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ]))

        // Star rating display
        let starSize: CGFloat = 42 * factor
        let starSpacing: CGFloat = 50 * factor
        let starsY = size.height * 0.55

        for i in 0..<3 {
            let filled = (i < awardedLaurel.stellarCount)
            let targetSprite = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
            targetSprite.size = CGSize(width: starSize, height: starSize)
            targetSprite.position = CGPoint(
                x: size.width / 2 + CGFloat(i - 1) * starSpacing,
                y: starsY
            )
            targetSprite.alpha = 0
            targetSprite.setScale(0.3)
            addChild(targetSprite)

            let delay = 0.5 + Double(i) * 0.2
            targetSprite.run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.group([
                    SKAction.fadeAlpha(to: filled ? 1.0 : 0.25, duration: 0.3),
                    SKAction.scale(to: 1.0, duration: 0.3)
                ]),
                filled ? KinesisFactory.triumphantBurst() : SKAction.wait(forDuration: 0)
            ]))
        }

        // Steps info
        let stepsLabel = SKLabelNode(text: "Steps used: \(cadenceExpended)")
        stepsLabel.fontName = "AvenirNext-Medium"
        stepsLabel.fontSize = 15 * factor
        stepsLabel.fontColor = SKColor.white.withAlphaComponent(0.8)
        stepsLabel.horizontalAlignmentMode = .center
        stepsLabel.verticalAlignmentMode = .center
        stepsLabel.position = CGPoint(x: size.width / 2, y: starsY - 45 * factor)
        stepsLabel.alpha = 0
        addChild(stepsLabel)
        stepsLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.2),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ]))

        // Confetti particles
        spawnCelebrationParticles()
    }

    private func assembleNavigationSigils() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let sigilWidth: CGFloat = 200 * factor
        let sigilHeight: CGFloat = 48 * factor
        let centerX = size.width / 2
        let baseY = size.height * 0.28

        // Next Level
        let hasNextLevel = stratumIndex < MutualismOrchestrator.totalStrata
        if hasNextLevel {
            let proceedSigil = SigilNode(
                caption: "Proceed",
                magnitude: CGSize(width: sigilWidth, height: sigilHeight),
                fontSize: 18 * factor,
                cornerCurvature: 14 * factor
            )
            proceedSigil.position = CGPoint(x: centerX, y: baseY)
            proceedSigil.alpha = 0
            proceedSigil.setScale(0.8)
            proceedSigil.onActivation = { [weak self] in
                guard let self = self, let skView = self.view else { return }
                MutualismOrchestrator.shared.proceedToNextStratum(in: skView)
            }
            addChild(proceedSigil)
            proceedSigil.run(KinesisFactory.curtainRise(for: proceedSigil, delay: 1.4))
        }

        // Retry
        let retrySigil = SigilNode(
            caption: "Retry",
            magnitude: CGSize(width: sigilWidth, height: sigilHeight),
            topPigment: SKColor.white.withAlphaComponent(0.3),
            bottomPigment: SKColor.white.withAlphaComponent(0.2),
            textPigment: .white,
            fontSize: 17 * factor,
            cornerCurvature: 14 * factor
        )
        retrySigil.position = CGPoint(x: centerX, y: baseY - 62 * factor)
        retrySigil.alpha = 0
        retrySigil.setScale(0.8)
        retrySigil.onActivation = { [weak self] in
            guard let self = self, let skView = self.view else { return }
            MutualismOrchestrator.shared.commenceStratum(self.stratumIndex, in: skView)
        }
        addChild(retrySigil)
        retrySigil.run(KinesisFactory.curtainRise(for: retrySigil, delay: 1.5))

        // Back to Cartography
        let cartographySigil = SigilNode(
            caption: "Cartography",
            magnitude: CGSize(width: sigilWidth, height: sigilHeight),
            topPigment: SKColor.white.withAlphaComponent(0.2),
            bottomPigment: SKColor.white.withAlphaComponent(0.1),
            textPigment: SKColor.white.withAlphaComponent(0.8),
            fontSize: 15 * factor,
            cornerCurvature: 14 * factor
        )
        cartographySigil.position = CGPoint(x: centerX, y: baseY - 124 * factor)
        cartographySigil.alpha = 0
        cartographySigil.setScale(0.8)
        cartographySigil.onActivation = { [weak self] in
            guard let skView = self?.view else { return }
            MutualismOrchestrator.shared.retreatToCartography(in: skView)
        }
        addChild(cartographySigil)
        cartographySigil.run(KinesisFactory.curtainRise(for: cartographySigil, delay: 1.6))
    }

    private func spawnCelebrationParticles() {
        let allChroma = ChromaType.allCases
        for _ in 0..<20 {
            let chroma = allChroma.randomElement()!
            let particleSize = CGFloat.random(in: 4...10)
            let particle = SKShapeNode(circleOfRadius: particleSize)
            particle.fillColor = chroma.pigment.withAlphaComponent(0.7)
            particle.strokeColor = .clear
            particle.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: size.height + 20
            )
            particle.zPosition = -5
            addChild(particle)

            let fallDuration = Double.random(in: 2.0...4.0)
            let delay = Double.random(in: 0...1.5)
            let targetY = CGFloat.random(in: -20...(size.height * 0.4))
            let sway = CGFloat.random(in: -40...40)

            particle.run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.group([
                    SKAction.moveTo(y: targetY, duration: fallDuration),
                    SKAction.moveBy(x: sway, y: 0, duration: fallDuration),
                    SKAction.fadeAlpha(to: 0.1, duration: fallDuration),
                    SKAction.rotate(byAngle: .pi * CGFloat.random(in: 1...4), duration: fallDuration)
                ]),
                SKAction.removeFromParent()
            ]))
        }
    }
}
