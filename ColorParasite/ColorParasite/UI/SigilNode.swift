//
//  SigilNode.swift
//  ColorParasite
//
//  Custom button node with gradient background, rounded corners,
//  and press/release animation feedback.
//

import SpriteKit

final class SigilNode: SKNode {

    var onActivation: (() -> Void)?

    private let backdrop: SKShapeNode
    private let inscription: SKLabelNode
    private let emblemMagnitude: CGSize
    private var isDepressed = false

    init(
        caption: String,
        magnitude: CGSize,
        topPigment: SKColor = ChromaPalette.sigilPrimaryTop,
        bottomPigment: SKColor = ChromaPalette.sigilPrimaryBottom,
        textPigment: SKColor = .white,
        fontSize: CGFloat = 18,
        cornerCurvature: CGFloat = 14
    ) {
        self.emblemMagnitude = magnitude

        let roundedPath = UIBezierPath(
            roundedRect: CGRect(
                x: -magnitude.width / 2,
                y: -magnitude.height / 2,
                width: magnitude.width,
                height: magnitude.height
            ),
            cornerRadius: cornerCurvature
        )
        backdrop = SKShapeNode(path: roundedPath.cgPath)
        backdrop.lineWidth = 0
        backdrop.fillColor = topPigment
        backdrop.strokeColor = .clear

        let gradientTexture = ChromaPalette.fabricateGradientTexture(
            topPigment: topPigment,
            bottomPigment: bottomPigment,
            magnitude: magnitude
        )
        backdrop.fillTexture = gradientTexture

        inscription = SKLabelNode(text: caption)
        inscription.fontName = "AvenirNext-DemiBold"
        inscription.fontSize = fontSize
        inscription.fontColor = textPigment
        inscription.verticalAlignmentMode = .center
        inscription.horizontalAlignmentMode = .center

        super.init()

        self.isUserInteractionEnabled = true
        addChild(backdrop)
        addChild(inscription)

        applyShadowEffect()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyShadowEffect() {
        let shadowNode = SKShapeNode(path: backdrop.path!)
        shadowNode.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.12)
        shadowNode.strokeColor = .clear
        shadowNode.lineWidth = 0
        shadowNode.position = CGPoint(x: 0, y: -2)
        shadowNode.zPosition = -1
        insertChild(shadowNode, at: 0)
    }

    func updateCaption(_ newCaption: String) {
        inscription.text = newCaption
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDepressed = true
        let depress = SKAction.group([
            SKAction.scale(to: 0.92, duration: 0.08),
            SKAction.fadeAlpha(to: 0.85, duration: 0.08)
        ])
        run(depress)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDepressed else { return }
        isDepressed = false
        let release = SKAction.group([
            SKAction.scale(to: 1.0, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        run(release) { [weak self] in
            if let touch = touches.first, let selfNode = self {
                let loc = touch.location(in: selfNode)
                let halfW = selfNode.emblemMagnitude.width / 2 + 10
                let halfH = selfNode.emblemMagnitude.height / 2 + 10
                if abs(loc.x) <= halfW && abs(loc.y) <= halfH {
                    selfNode.onActivation?()
                }
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDepressed = false
        let release = SKAction.group([
            SKAction.scale(to: 1.0, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        run(release)
    }
}
