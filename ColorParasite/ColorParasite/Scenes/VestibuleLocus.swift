//
//  VestibuleLocus.swift
//  ColorParasite
//
//  Main menu scene with title, decorative orbs, and navigation buttons.
//

import SpriteKit

final class VestibuleLocus: SKScene {

    private var backdrop: GradientBackdrop!
    private var decorativeOrbs: [SKShapeNode] = []

    override func didMove(to view: SKView) {
        backgroundColor = .white
        assembleBackdrop()
        assembleTitleComposition()
        assembleNavigationSigils()
        assembleDecorativeOrbs()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if backdrop != nil {
            backdrop.recalibrate(
                to: size,
                zenithPigment: ChromaPalette.VestibuleGradient.zenith,
                nadirPigment: ChromaPalette.VestibuleGradient.nadir
            )
            backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.VestibuleGradient.zenith,
            nadirPigment: ChromaPalette.VestibuleGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleTitleComposition() {
        let factor = ViewportCalibrator.proportionFactor(for: size)

        // Main title
        let titleLabel = SKLabelNode(text: "Color")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 42 * factor
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.68)
        titleLabel.alpha = 0
        titleLabel.setScale(0.5)
        addChild(titleLabel)

        let subtitleLabel = SKLabelNode(text: "Parasite")
        subtitleLabel.fontName = "AvenirNext-Bold"
        subtitleLabel.fontSize = 42 * factor
        subtitleLabel.fontColor = SKColor.white.withAlphaComponent(0.92)
        subtitleLabel.horizontalAlignmentMode = .center
        subtitleLabel.verticalAlignmentMode = .center
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.68 - 48 * factor)
        subtitleLabel.alpha = 0
        subtitleLabel.setScale(0.5)
        addChild(subtitleLabel)

        // Tagline
        let tagline = SKLabelNode(text: "Colonize. Transform. Evolve.")
        tagline.fontName = "AvenirNext-MediumItalic"
        tagline.fontSize = 14 * factor
        tagline.fontColor = SKColor.white.withAlphaComponent(0.7)
        tagline.horizontalAlignmentMode = .center
        tagline.verticalAlignmentMode = .center
        tagline.position = CGPoint(x: size.width / 2, y: size.height * 0.68 - 90 * factor)
        tagline.alpha = 0
        addChild(tagline)

        // Entrance animations
        titleLabel.run(KinesisFactory.curtainRise(for: titleLabel, delay: 0.1))
        subtitleLabel.run(KinesisFactory.curtainRise(for: subtitleLabel, delay: 0.25))
        tagline.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeAlpha(to: 1.0, duration: 0.4)
        ]))
    }

    private func assembleNavigationSigils() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let sigilWidth: CGFloat = 220 * factor
        let sigilHeight: CGFloat = 52 * factor
        let smallSigilWidth: CGFloat = 100 * factor
        let smallSigilHeight: CGFloat = 42 * factor
        let centerX = size.width / 2
        let mainStartY = size.height * 0.42

        // Embark (Start) button
        let embarkSigil = SigilNode(
            caption: "Embark",
            magnitude: CGSize(width: sigilWidth, height: sigilHeight),
            fontSize: 19 * factor,
            cornerCurvature: 16 * factor
        )
        embarkSigil.position = CGPoint(x: centerX, y: mainStartY)
        embarkSigil.alpha = 0
        embarkSigil.setScale(0.8)
        embarkSigil.onActivation = { [weak self] in
            self?.embarkLatestStratum()
        }
        addChild(embarkSigil)

        // Level Select button
        let cartographySigil = SigilNode(
            caption: "Cartography",
            magnitude: CGSize(width: sigilWidth, height: sigilHeight),
            topPigment: SKColor.white.withAlphaComponent(0.25),
            bottomPigment: SKColor.white.withAlphaComponent(0.15),
            textPigment: .white,
            fontSize: 17 * factor,
            cornerCurvature: 16 * factor
        )
        cartographySigil.position = CGPoint(x: centerX, y: mainStartY - 64 * factor)
        cartographySigil.alpha = 0
        cartographySigil.setScale(0.8)
        cartographySigil.onActivation = { [weak self] in
            self?.navigateToCartography()
        }
        addChild(cartographySigil)

        // Bottom row: 2x2 grid of small buttons
        let bottomRowY1 = size.height * 0.18
        let bottomRowY2 = bottomRowY1 - 52 * factor
        let hSpacing: CGFloat = 56 * factor

        let transparentTop = SKColor.white.withAlphaComponent(0.20)
        let transparentBottom = SKColor.white.withAlphaComponent(0.10)

        // Tutorial button
        let tutorialSigil = SigilNode(
            caption: "Tutorial",
            magnitude: CGSize(width: smallSigilWidth, height: smallSigilHeight),
            topPigment: transparentTop,
            bottomPigment: transparentBottom,
            textPigment: .white,
            fontSize: 14 * factor,
            cornerCurvature: 12 * factor
        )
        tutorialSigil.position = CGPoint(x: centerX - hSpacing, y: bottomRowY1)
        tutorialSigil.alpha = 0
        tutorialSigil.setScale(0.8)
        tutorialSigil.onActivation = { [weak self] in
            self?.navigateToTutorial()
        }
        addChild(tutorialSigil)

        // Achievements button
        let achievementsSigil = SigilNode(
            caption: "Stats",
            magnitude: CGSize(width: smallSigilWidth, height: smallSigilHeight),
            topPigment: transparentTop,
            bottomPigment: transparentBottom,
            textPigment: .white,
            fontSize: 14 * factor,
            cornerCurvature: 12 * factor
        )
        achievementsSigil.position = CGPoint(x: centerX + hSpacing, y: bottomRowY1)
        achievementsSigil.alpha = 0
        achievementsSigil.setScale(0.8)
        achievementsSigil.onActivation = { [weak self] in
            self?.navigateToAchievements()
        }
        addChild(achievementsSigil)

        // Settings button
        let settingsSigil = SigilNode(
            caption: "Settings",
            magnitude: CGSize(width: smallSigilWidth, height: smallSigilHeight),
            topPigment: transparentTop,
            bottomPigment: transparentBottom,
            textPigment: .white,
            fontSize: 14 * factor,
            cornerCurvature: 12 * factor
        )
        settingsSigil.position = CGPoint(x: centerX - hSpacing, y: bottomRowY2)
        settingsSigil.alpha = 0
        settingsSigil.setScale(0.8)
        settingsSigil.onActivation = { [weak self] in
            self?.navigateToSettings()
        }
        addChild(settingsSigil)

        // Reset Progress button
        let resetSigil = SigilNode(
            caption: "Reset",
            magnitude: CGSize(width: smallSigilWidth, height: smallSigilHeight),
            topPigment: SKColor(red: 0.85, green: 0.25, blue: 0.25, alpha: 0.6),
            bottomPigment: SKColor(red: 0.75, green: 0.20, blue: 0.20, alpha: 0.5),
            textPigment: .white,
            fontSize: 14 * factor,
            cornerCurvature: 12 * factor
        )
        resetSigil.position = CGPoint(x: centerX + hSpacing, y: bottomRowY2)
        resetSigil.alpha = 0
        resetSigil.setScale(0.8)
        resetSigil.onActivation = { [weak self] in
            self?.confirmResetProgress()
        }
        addChild(resetSigil)

        // Animate in
        embarkSigil.run(KinesisFactory.curtainRise(for: embarkSigil, delay: 0.4))
        cartographySigil.run(KinesisFactory.curtainRise(for: cartographySigil, delay: 0.55))
        tutorialSigil.run(KinesisFactory.curtainRise(for: tutorialSigil, delay: 0.65))
        achievementsSigil.run(KinesisFactory.curtainRise(for: achievementsSigil, delay: 0.70))
        settingsSigil.run(KinesisFactory.curtainRise(for: settingsSigil, delay: 0.75))
        resetSigil.run(KinesisFactory.curtainRise(for: resetSigil, delay: 0.80))
    }

    private func assembleDecorativeOrbs() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let allChroma = ChromaType.allCases

        for i in 0..<8 {
            let chroma = allChroma[i % allChroma.count]
            let radius = CGFloat.random(in: 8...18) * factor
            let orb = SKShapeNode(circleOfRadius: radius)
            orb.fillColor = chroma.pigment.withAlphaComponent(0.3)
            orb.strokeColor = chroma.luminousPigment.withAlphaComponent(0.2)
            orb.lineWidth = 1.5

            let xPos = CGFloat.random(in: 30...(size.width - 30))
            let yPos = CGFloat.random(in: (size.height * 0.1)...(size.height * 0.9))
            orb.position = CGPoint(x: xPos, y: yPos)
            orb.zPosition = -5
            orb.alpha = 0

            addChild(orb)
            decorativeOrbs.append(orb)

            // Float animation
            let fadeIn = SKAction.fadeAlpha(to: 0.4, duration: Double.random(in: 0.5...1.5))
            let floatUp = SKAction.moveBy(x: 0, y: CGFloat.random(in: 15...30), duration: Double.random(in: 3...5))
            let floatDown = SKAction.moveBy(x: 0, y: CGFloat.random(in: -30 ... -15), duration: Double.random(in: 3...5))
            floatUp.timingMode = .easeInEaseOut
            floatDown.timingMode = .easeInEaseOut
            let floatCycle = SKAction.repeatForever(SKAction.sequence([floatUp, floatDown]))

            orb.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.15),
                fadeIn,
                floatCycle
            ]))
        }
    }

    // MARK: - Navigation

    private func embarkLatestStratum() {
        guard let skView = self.view else { return }
        let chronicle = MutualismOrchestrator.shared.chronicle
        let targetIndex = min(chronicle.unlockedStratumIndex, MutualismOrchestrator.totalStrata)
        MutualismOrchestrator.shared.commenceStratum(targetIndex, in: skView)
    }

    private func navigateToCartography() {
        guard let skView = self.view else { return }
        MutualismOrchestrator.shared.retreatToCartography(in: skView)
    }

    private func navigateToSettings() {
        guard let skView = self.view else { return }
        MutualismOrchestrator.shared.navigateToSettings(in: skView)
    }

    private func navigateToAchievements() {
        guard let skView = self.view else { return }
        MutualismOrchestrator.shared.navigateToAchievements(in: skView)
    }

    private func navigateToTutorial() {
        guard let skView = self.view else { return }
        MutualismOrchestrator.shared.navigateToTutorial(in: skView)
    }

    private func confirmResetProgress() {
        let manifesto = ManifestoNode(
            heading: "Reset Progress",
            proclamation: "This will erase all your stars and progress. Are you sure?",
            edicts: [
                (caption: "Cancel", handler: {}),
                (caption: "Reset All", handler: { [weak self] in
                    guard let skView = self?.view else { return }
                    MutualismOrchestrator.shared.purgeAllProgress(in: skView)
                })
            ],
            sceneMagnitude: size
        )
        manifesto.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(manifesto)
    }
}
