//
//  AchievementsLocus.swift
//  ColorParasite
//
//  Achievements and statistics scene showing player progress.
//

import SpriteKit

final class AchievementsLocus: SKScene {

    private var backdrop: GradientBackdrop!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        assembleBackdrop()
        assembleHeader()
        assembleStatistics()
        assembleBackButton()
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.AchievementsGradient.zenith,
            nadirPigment: ChromaPalette.AchievementsGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleHeader() {
        let factor = ViewportCalibrator.proportionFactor(for: size)

        let titleLabel = SKLabelNode(text: "Achievements")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 32 * factor
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(titleLabel)
    }

    private func assembleStatistics() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let chronicle = MutualismOrchestrator.shared.chronicle
        let centerX = size.width / 2

        let totalStars = chronicle.aggregateLaurels
        let levelsCleared = chronicle.laurels.count
        let maxPossibleStars = MutualismOrchestrator.totalStrata * 3
        let goldCount = chronicle.laurels.values.filter { $0 == .gold }.count
        let silverCount = chronicle.laurels.values.filter { $0 == .silver }.count
        let bronzeCount = chronicle.laurels.values.filter { $0 == .bronze }.count

        let stats: [(icon: String, label: String, value: String, useTargetImage: Bool)] = [
            ("", "Total Stars", "\(totalStars) / \(maxPossibleStars)", true),
            ("🏆", "Levels Cleared", "\(levelsCleared) / \(MutualismOrchestrator.totalStrata)", false),
            ("🥇", "Gold", "\(goldCount)", false),
            ("🥈", "Silver", "\(silverCount)", false),
            ("🥉", "Bronze", "\(bronzeCount)", false)
        ]

        let startY = size.height * 0.68
        let rowSpacing: CGFloat = 60 * factor
        let panelWidth: CGFloat = 280 * factor
        let panelHeight: CGFloat = CGFloat(stats.count) * rowSpacing + 30 * factor

        // Background panel
        let panelPath = UIBezierPath(
            roundedRect: CGRect(x: -panelWidth / 2, y: -panelHeight / 2, width: panelWidth, height: panelHeight),
            cornerRadius: 16 * factor
        )
        let panel = SKShapeNode(path: panelPath.cgPath)
        panel.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        panel.strokeColor = SKColor.white.withAlphaComponent(0.15)
        panel.lineWidth = 1
        panel.position = CGPoint(x: centerX, y: startY - panelHeight / 2 + 15 * factor)
        addChild(panel)

        for (idx, stat) in stats.enumerated() {
            let y = startY - CGFloat(idx) * rowSpacing

            if stat.useTargetImage {
                let targetIcon = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
                targetIcon.size = CGSize(width: 22 * factor, height: 22 * factor)
                targetIcon.position = CGPoint(x: centerX - panelWidth / 2 + 30 * factor, y: y)
                addChild(targetIcon)
            } else {
                let iconLabel = SKLabelNode(text: stat.icon)
                iconLabel.fontSize = 22 * factor
                iconLabel.verticalAlignmentMode = .center
                iconLabel.horizontalAlignmentMode = .left
                iconLabel.position = CGPoint(x: centerX - panelWidth / 2 + 20 * factor, y: y)
                addChild(iconLabel)
            }

            let nameLabel = SKLabelNode(text: stat.label)
            nameLabel.fontName = "AvenirNext-Medium"
            nameLabel.fontSize = 16 * factor
            nameLabel.fontColor = SKColor.white.withAlphaComponent(0.9)
            nameLabel.verticalAlignmentMode = .center
            nameLabel.horizontalAlignmentMode = .left
            nameLabel.position = CGPoint(x: centerX - panelWidth / 2 + 55 * factor, y: y)
            addChild(nameLabel)

            let valueLabel = SKLabelNode(text: stat.value)
            valueLabel.fontName = "AvenirNext-Bold"
            valueLabel.fontSize = 17 * factor
            valueLabel.fontColor = .white
            valueLabel.verticalAlignmentMode = .center
            valueLabel.horizontalAlignmentMode = .right
            valueLabel.position = CGPoint(x: centerX + panelWidth / 2 - 20 * factor, y: y)
            addChild(valueLabel)
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
        backSigil.position = CGPoint(x: size.width / 2, y: size.height * 0.12)
        backSigil.onActivation = { [weak self] in
            guard let skView = self?.view else { return }
            MutualismOrchestrator.shared.retreatToVestibule(in: skView)
        }
        addChild(backSigil)
    }
}
