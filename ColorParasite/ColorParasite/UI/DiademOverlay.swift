//
//  DiademOverlay.swift
//  ColorParasite
//
//  In-game heads-up display showing level info, step count, and controls.
//

import SpriteKit

final class DiademOverlay: SKNode {

    private let stratumBadge: SKLabelNode
    private let cadenceCounter: SKLabelNode
    private let retreatSigil: SigilNode
    private let resetSigil: SigilNode

    var onRetreatActivated: (() -> Void)?
    var onResetActivated: (() -> Void)?

    init(sceneMagnitude: CGSize, safeAreaPadding: UIEdgeInsets = .zero) {
        let factor = ViewportCalibrator.proportionFactor(for: sceneMagnitude)
        let topPadding = safeAreaPadding.top + 12 * factor
        let bottomPadding = safeAreaPadding.bottom + 12 * factor

        // Level badge
        stratumBadge = SKLabelNode(text: "Level 1")
        stratumBadge.fontName = "AvenirNext-Bold"
        stratumBadge.fontSize = 20 * factor
        stratumBadge.fontColor = ChromaPalette.obsidianText
        stratumBadge.horizontalAlignmentMode = .center
        stratumBadge.verticalAlignmentMode = .center
        stratumBadge.position = CGPoint(
            x: sceneMagnitude.width / 2,
            y: sceneMagnitude.height - topPadding - 25 * factor
        )

        // Step counter
        cadenceCounter = SKLabelNode(text: "Steps: 0/5")
        cadenceCounter.fontName = "AvenirNext-Medium"
        cadenceCounter.fontSize = 16 * factor
        cadenceCounter.fontColor = ChromaPalette.slateText
        cadenceCounter.horizontalAlignmentMode = .center
        cadenceCounter.verticalAlignmentMode = .center
        cadenceCounter.position = CGPoint(
            x: sceneMagnitude.width / 2,
            y: sceneMagnitude.height - topPadding - 52 * factor
        )

        // Back button
        let sigilSize = CGSize(width: 44 * factor, height: 44 * factor)
        retreatSigil = SigilNode(
            caption: "‹",
            magnitude: sigilSize,
            topPigment: SKColor.white.withAlphaComponent(0.9),
            bottomPigment: SKColor.white.withAlphaComponent(0.7),
            textPigment: ChromaPalette.obsidianText,
            fontSize: 24 * factor,
            cornerCurvature: 12 * factor
        )
        retreatSigil.position = CGPoint(
            x: 35 * factor,
            y: sceneMagnitude.height - topPadding - 25 * factor
        )

        // Reset button
        let resetSize = CGSize(width: 120 * factor, height: 40 * factor)
        resetSigil = SigilNode(
            caption: "Reset",
            magnitude: resetSize,
            topPigment: SKColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0),
            bottomPigment: SKColor(red: 0.88, green: 0.88, blue: 0.92, alpha: 1.0),
            textPigment: ChromaPalette.slateText,
            fontSize: 15 * factor,
            cornerCurvature: 10 * factor
        )
        resetSigil.position = CGPoint(
            x: sceneMagnitude.width / 2,
            y: bottomPadding + 30 * factor
        )

        super.init()

        self.zPosition = 100
        addChild(stratumBadge)
        addChild(cadenceCounter)
        addChild(retreatSigil)
        addChild(resetSigil)

        retreatSigil.onActivation = { [weak self] in
            self?.onRetreatActivated?()
        }

        resetSigil.onActivation = { [weak self] in
            self?.onResetActivated?()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshStratumBadge(index: Int) {
        stratumBadge.text = "Level \(index)"
    }

    func refreshCadenceCounter(current: Int, maximum: Int) {
        cadenceCounter.text = "Steps: \(current)/\(maximum)"

        // Warning color when running low
        let remaining = maximum - current
        if remaining <= 1 && remaining >= 0 {
            cadenceCounter.fontColor = SKColor(red: 0.95, green: 0.30, blue: 0.30, alpha: 1.0)
        } else if remaining <= 3 {
            cadenceCounter.fontColor = SKColor(red: 0.95, green: 0.65, blue: 0.20, alpha: 1.0)
        } else {
            cadenceCounter.fontColor = ChromaPalette.slateText
        }
    }
}
