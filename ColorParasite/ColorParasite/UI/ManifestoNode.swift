//
//  ManifestoNode.swift
//  ColorParasite
//
//  Custom dialog overlay replacing system UIAlertController.
//  Provides a styled popup with title, body text, and action buttons.
//

import SpriteKit

final class ManifestoNode: SKNode {

    private let scrimNode: SKSpriteNode
    private let parchmentNode: SKShapeNode
    private var sigilNodes: [SigilNode] = []

    init(
        heading: String,
        proclamation: String,
        edicts: [(caption: String, handler: () -> Void)],
        sceneMagnitude: CGSize
    ) {
        let factor = ViewportCalibrator.proportionFactor(for: sceneMagnitude)

        // Semi-transparent backdrop scrim
        scrimNode = SKSpriteNode(color: SKColor(red: 0, green: 0, blue: 0, alpha: 0.55), size: sceneMagnitude)
        scrimNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scrimNode.zPosition = 0

        // Panel
        let panelWidth: CGFloat = 300 * factor
        let panelHeight: CGFloat = max(200 * factor, CGFloat(edicts.count) * 55 * factor + 120 * factor)
        let panelPath = UIBezierPath(
            roundedRect: CGRect(x: -panelWidth / 2, y: -panelHeight / 2, width: panelWidth, height: panelHeight),
            cornerRadius: 20 * factor
        )
        parchmentNode = SKShapeNode(path: panelPath.cgPath)
        parchmentNode.fillColor = ChromaPalette.parchmentWhite
        parchmentNode.strokeColor = SKColor(red: 0.85, green: 0.85, blue: 0.90, alpha: 1.0)
        parchmentNode.lineWidth = 1
        parchmentNode.zPosition = 1

        super.init()

        self.zPosition = 200
        self.isUserInteractionEnabled = true

        addChild(scrimNode)
        addChild(parchmentNode)

        // Title label
        let headingLabel = SKLabelNode(text: heading)
        headingLabel.fontName = "AvenirNext-Bold"
        headingLabel.fontSize = 22 * factor
        headingLabel.fontColor = ChromaPalette.obsidianText
        headingLabel.verticalAlignmentMode = .center
        headingLabel.horizontalAlignmentMode = .center
        headingLabel.position = CGPoint(x: 0, y: panelHeight / 2 - 35 * factor)
        parchmentNode.addChild(headingLabel)

        // Body text
        let bodyLabel = SKLabelNode(text: proclamation)
        bodyLabel.fontName = "AvenirNext-Regular"
        bodyLabel.fontSize = 15 * factor
        bodyLabel.fontColor = ChromaPalette.slateText
        bodyLabel.verticalAlignmentMode = .center
        bodyLabel.horizontalAlignmentMode = .center
        bodyLabel.numberOfLines = 0
        bodyLabel.preferredMaxLayoutWidth = panelWidth - 40 * factor
        bodyLabel.position = CGPoint(x: 0, y: panelHeight / 2 - 75 * factor)
        parchmentNode.addChild(bodyLabel)

        // Action buttons
        let sigilWidth: CGFloat = 220 * factor
        let sigilHeight: CGFloat = 44 * factor
        let startY: CGFloat = -panelHeight / 2 + 30 * factor + CGFloat(edicts.count - 1) * 55 * factor

        for (idx, edict) in edicts.enumerated() {
            let isPrimary = (idx == 0)
            let sigil = SigilNode(
                caption: edict.caption,
                magnitude: CGSize(width: sigilWidth, height: sigilHeight),
                topPigment: isPrimary ? ChromaPalette.sigilPrimaryTop : ChromaPalette.sigilSecondaryTop,
                bottomPigment: isPrimary ? ChromaPalette.sigilPrimaryBottom : ChromaPalette.sigilSecondaryBottom,
                textPigment: isPrimary ? .white : ChromaPalette.obsidianText,
                fontSize: 16 * factor,
                cornerCurvature: 12 * factor
            )
            sigil.position = CGPoint(x: 0, y: startY - CGFloat(idx) * 55 * factor)
            sigil.zPosition = 2
            sigil.onActivation = { [weak self] in
                self?.dismissWithKinesis {
                    edict.handler()
                }
            }
            parchmentNode.addChild(sigil)
            sigilNodes.append(sigil)
        }

        // Entrance animation
        self.alpha = 0
        parchmentNode.setScale(0.7)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.25)
        scaleUp.timingMode = .easeOut
        parchmentNode.run(scaleUp)
        self.run(fadeIn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func dismissWithKinesis(completion: @escaping () -> Void) {
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.2)
        parchmentNode.run(scaleDown)
        self.run(fadeOut) { [weak self] in
            self?.removeFromParent()
            completion()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Consume touches to prevent pass-through
    }
}
