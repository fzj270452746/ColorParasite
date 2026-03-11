//
//  TutorialLocus.swift
//  ColorParasite
//
//  Tutorial and help scene explaining game rules.
//

import SpriteKit

final class TutorialLocus: SKScene {

    private var backdrop: GradientBackdrop!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        assembleBackdrop()
        assembleHeader()
        assembleRules()
        assembleBackButton()
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.TutorialGradient.zenith,
            nadirPigment: ChromaPalette.TutorialGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleHeader() {
        let factor = ViewportCalibrator.proportionFactor(for: size)

        let titleLabel = SKLabelNode(text: "How to Play")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 32 * factor
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.88)
        addChild(titleLabel)
    }

    private func assembleRules() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let centerX = size.width / 2
        let panelWidth: CGFloat = 300 * factor

        let rules: [(title: String, body: String)] = [
            ("Objective", "Transform all cells to one color to win the level."),
            ("Movement", "Tap a neighboring cell to move your parasite into it."),
            ("Color Rules", "Your parasite absorbs the color of cells it enters. Same-color cells cannot be consumed."),
            ("Stars", "Complete levels in fewer moves to earn more stars (Gold, Silver, Bronze)."),
            ("Special Cells", "Look out for wormholes, barriers, and nomadic cells that add extra challenge!")
        ]

        let startY = size.height * 0.78
        let totalHeight = CGFloat(rules.count) * 95 * factor + 20 * factor

        // Background panel
        let panelPath = UIBezierPath(
            roundedRect: CGRect(x: -panelWidth / 2, y: -totalHeight / 2, width: panelWidth, height: totalHeight),
            cornerRadius: 16 * factor
        )
        let panel = SKShapeNode(path: panelPath.cgPath)
        panel.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        panel.strokeColor = SKColor.white.withAlphaComponent(0.15)
        panel.lineWidth = 1
        panel.position = CGPoint(x: centerX, y: startY - totalHeight / 2 + 10 * factor)
        addChild(panel)

        for (idx, rule) in rules.enumerated() {
            let y = startY - CGFloat(idx) * 95 * factor

            let numberLabel = SKLabelNode(text: "\(idx + 1)")
            numberLabel.fontName = "AvenirNext-Bold"
            numberLabel.fontSize = 20 * factor
            numberLabel.fontColor = SKColor.white.withAlphaComponent(0.6)
            numberLabel.verticalAlignmentMode = .top
            numberLabel.horizontalAlignmentMode = .left
            numberLabel.position = CGPoint(x: centerX - panelWidth / 2 + 15 * factor, y: y)
            addChild(numberLabel)

            let titleLabel = SKLabelNode(text: rule.title)
            titleLabel.fontName = "AvenirNext-Bold"
            titleLabel.fontSize = 16 * factor
            titleLabel.fontColor = .white
            titleLabel.verticalAlignmentMode = .top
            titleLabel.horizontalAlignmentMode = .left
            titleLabel.position = CGPoint(x: centerX - panelWidth / 2 + 40 * factor, y: y)
            addChild(titleLabel)

            let bodyLabel = SKLabelNode(text: rule.body)
            bodyLabel.fontName = "AvenirNext-Regular"
            bodyLabel.fontSize = 13 * factor
            bodyLabel.fontColor = SKColor.white.withAlphaComponent(0.85)
            bodyLabel.verticalAlignmentMode = .top
            bodyLabel.horizontalAlignmentMode = .left
            bodyLabel.numberOfLines = 0
            bodyLabel.preferredMaxLayoutWidth = panelWidth - 55 * factor
            bodyLabel.position = CGPoint(x: centerX - panelWidth / 2 + 40 * factor, y: y - 22 * factor)
            addChild(bodyLabel)
        }
    }

    private func assembleBackButton() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let backSigil = SigilNode(
            caption: "Back",
            magnitude: CGSize(width: 160 * factor, height: 44 * factor),
            topPigment: SKColor.white.withAlphaComponent(0.25),
            bottomPigment: SKColor.white.withAlphaComponent(0.15),
            textPigment: .white,
            fontSize: 17 * factor,
            cornerCurvature: 12 * factor
        )
        backSigil.position = CGPoint(x: size.width / 2, y: size.height * 0.06)
        backSigil.onActivation = { [weak self] in
            guard let skView = self?.view else { return }
            MutualismOrchestrator.shared.retreatToVestibule(in: skView)
        }
        addChild(backSigil)
    }
}
