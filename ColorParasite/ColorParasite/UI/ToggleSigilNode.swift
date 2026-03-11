//
//  ToggleSigilNode.swift
//  ColorParasite
//
//  A toggle switch node with label, for settings rows.
//

import SpriteKit

final class ToggleSigilNode: SKNode {

    var isOn: Bool {
        didSet { refreshAppearance() }
    }

    var onToggled: ((Bool) -> Void)?

    private let trackNode: SKShapeNode
    private let thumbNode: SKShapeNode
    private let captionLabel: SKLabelNode
    private let trackWidth: CGFloat
    private let trackHeight: CGFloat
    private let thumbRadius: CGFloat

    init(caption: String, isOn: Bool, factor: CGFloat) {
        self.isOn = isOn
        self.trackWidth = 50 * factor
        self.trackHeight = 28 * factor
        self.thumbRadius = 11 * factor

        let trackPath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: -trackHeight / 2, width: trackWidth, height: trackHeight),
            cornerRadius: trackHeight / 2
        )
        trackNode = SKShapeNode(path: trackPath.cgPath)
        trackNode.lineWidth = 0
        trackNode.strokeColor = .clear

        thumbNode = SKShapeNode(circleOfRadius: thumbRadius)
        thumbNode.lineWidth = 0
        thumbNode.strokeColor = .clear
        thumbNode.fillColor = .white
        thumbNode.zPosition = 1

        captionLabel = SKLabelNode(text: caption)
        captionLabel.fontName = "AvenirNext-Medium"
        captionLabel.fontSize = 17 * factor
        captionLabel.fontColor = .white
        captionLabel.verticalAlignmentMode = .center
        captionLabel.horizontalAlignmentMode = .left

        super.init()

        self.isUserInteractionEnabled = true
        addChild(captionLabel)
        addChild(trackNode)
        addChild(thumbNode)

        captionLabel.position = CGPoint(x: -120 * factor, y: 0)
        trackNode.position = CGPoint(x: 60 * factor, y: 0)

        refreshAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func refreshAppearance() {
        let onColor = ChromaPalette.sigilPrimaryTop
        let offColor = SKColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 0.6)
        trackNode.fillColor = isOn ? onColor : offColor

        let trackX = trackNode.position.x
        let targetX = isOn
            ? trackX + trackWidth - thumbRadius - 3
            : trackX + thumbRadius + 3
        let move = SKAction.moveTo(x: targetX, duration: 0.15)
        move.timingMode = .easeOut
        thumbNode.run(move)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn.toggle()
        onToggled?(isOn)
    }
}
