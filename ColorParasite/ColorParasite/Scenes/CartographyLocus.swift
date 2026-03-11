//
//  CartographyLocus.swift
//  ColorParasite
//
//  Level selection scene displaying a scrollable grid of level cells.
//

import SpriteKit

final class CartographyLocus: SKScene {

    private var backdrop: GradientBackdrop!
    private let scrollContainer = SKNode()
    private var lastTouchY: CGFloat = 0
    private var scrollOffset: CGFloat = 0
    private var maxScrollOffset: CGFloat = 0
    private var chronicle: ChronicleRecord!

    private let cellsPerRow: Int = 5
    private let totalStrata: Int = MutualismOrchestrator.totalStrata

    override func didMove(to view: SKView) {
        backgroundColor = .white
        chronicle = ChronicleVault.shared.excavate()

        assembleBackdrop()
        assembleHeader()
        assembleLevelGrid()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if backdrop != nil {
            backdrop.recalibrate(
                to: size,
                zenithPigment: ChromaPalette.CartographyGradient.zenith,
                nadirPigment: ChromaPalette.CartographyGradient.nadir
            )
            backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.CartographyGradient.zenith,
            nadirPigment: ChromaPalette.CartographyGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleHeader() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let safeTop: CGFloat = 50 * factor

        let titleLabel = SKLabelNode(text: "Cartography")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 26 * factor
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - safeTop - 20 * factor)
        titleLabel.zPosition = 50
        addChild(titleLabel)

        // Back button
        let retreatSigil = SigilNode(
            caption: "‹",
            magnitude: CGSize(width: 40 * factor, height: 40 * factor),
            topPigment: SKColor.white.withAlphaComponent(0.3),
            bottomPigment: SKColor.white.withAlphaComponent(0.2),
            textPigment: .white,
            fontSize: 22 * factor,
            cornerCurvature: 10 * factor
        )
        retreatSigil.position = CGPoint(x: 35 * factor, y: size.height - safeTop - 20 * factor)
        retreatSigil.zPosition = 50
        retreatSigil.onActivation = { [weak self] in
            guard let self = self, let skView = self.view else { return }
            MutualismOrchestrator.shared.retreatToVestibule(in: skView)
        }
        addChild(retreatSigil)

        // Stars count — target icon + number
        let targetIcon = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
        let iconSize: CGFloat = 18 * factor
        targetIcon.size = CGSize(width: iconSize, height: iconSize)
        targetIcon.position = CGPoint(x: size.width - 45 * factor, y: size.height - safeTop - 20 * factor)
        targetIcon.zPosition = 50
        addChild(targetIcon)

        let starsLabel = SKLabelNode(text: "\(chronicle.aggregateLaurels)")
        starsLabel.fontName = "AvenirNext-DemiBold"
        starsLabel.fontSize = 16 * factor
        starsLabel.fontColor = SKColor.white.withAlphaComponent(0.9)
        starsLabel.horizontalAlignmentMode = .right
        starsLabel.verticalAlignmentMode = .center
        starsLabel.position = CGPoint(x: size.width - 55 * factor, y: size.height - safeTop - 20 * factor)
        starsLabel.zPosition = 50
        addChild(starsLabel)
    }

    private func assembleLevelGrid() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let safeTop: CGFloat = 50 * factor
        let gridTopY = size.height - safeTop - 60 * factor

        scrollContainer.zPosition = 10
        addChild(scrollContainer)

        let cellSize: CGFloat = (size.width - 30 * factor) / CGFloat(cellsPerRow) - 8 * factor
        let spacing: CGFloat = 8 * factor
        let totalCellWidth = cellSize + spacing
        let leftMargin = (size.width - CGFloat(cellsPerRow) * totalCellWidth + spacing) / 2

        let totalRows = Int(ceil(Double(totalStrata) / Double(cellsPerRow)))

        for i in 0..<totalStrata {
            let row = i / cellsPerRow
            let col = i % cellsPerRow
            let stratumIndex = i + 1

            let xPos = leftMargin + CGFloat(col) * totalCellWidth + cellSize / 2
            let yPos = gridTopY - CGFloat(row) * totalCellWidth - cellSize / 2

            let cellNode = fabricateLevelCell(
                stratumIndex: stratumIndex,
                cellSize: cellSize,
                factor: factor
            )
            cellNode.position = CGPoint(x: xPos, y: yPos)
            scrollContainer.addChild(cellNode)
        }

        let totalGridHeight = CGFloat(totalRows) * totalCellWidth
        let visibleHeight = gridTopY - 20 * factor
        maxScrollOffset = max(0, totalGridHeight - visibleHeight)
    }

    private func fabricateLevelCell(stratumIndex: Int, cellSize: CGFloat, factor: CGFloat) -> SKNode {
        let container = SKNode()
        container.name = "cell_\(stratumIndex)"

        let isUnlocked = stratumIndex <= chronicle.unlockedStratumIndex
        let laurel = chronicle.laurelForStratum(stratumIndex)

        // Background rounded rect
        let bgPath = UIBezierPath(
            roundedRect: CGRect(x: -cellSize / 2, y: -cellSize / 2, width: cellSize, height: cellSize),
            cornerRadius: 8 * factor
        )
        let bgNode = SKShapeNode(path: bgPath.cgPath)

        if isUnlocked {
            bgNode.fillColor = SKColor.white.withAlphaComponent(0.9)
            bgNode.strokeColor = SKColor.white.withAlphaComponent(0.3)
        } else {
            bgNode.fillColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
            bgNode.strokeColor = .clear
        }
        bgNode.lineWidth = 1
        container.addChild(bgNode)

        // Level number
        let numLabel = SKLabelNode(text: "\(stratumIndex)")
        numLabel.fontName = isUnlocked ? "AvenirNext-Bold" : "AvenirNext-Medium"
        numLabel.fontSize = 16 * factor
        numLabel.fontColor = isUnlocked ? ChromaPalette.obsidianText : SKColor.white.withAlphaComponent(0.5)
        numLabel.verticalAlignmentMode = .center
        numLabel.horizontalAlignmentMode = .center
        numLabel.position = CGPoint(x: 0, y: laurel != .none ? 4 * factor : 0)
        container.addChild(numLabel)

        // Stars — target icons
        if laurel != .none {
            let miniSize: CGFloat = 9 * factor
            let miniSpacing: CGFloat = 11 * factor
            let startX = -CGFloat(2) * miniSpacing / 2
            for s in 0..<3 {
                let isFilled = (s < laurel.stellarCount)
                let miniTarget = SKSpriteNode(texture: SKTexture(imageNamed: "target"))
                miniTarget.size = CGSize(width: miniSize, height: miniSize)
                miniTarget.alpha = isFilled ? 1.0 : 0.25
                miniTarget.position = CGPoint(x: startX + CGFloat(s) * miniSpacing, y: -10 * factor)
                container.addChild(miniTarget)
            }
        }

        // Lock icon for locked levels
        if !isUnlocked {
            let lockLabel = SKLabelNode(text: "🔒")
            lockLabel.fontSize = 10 * factor
            lockLabel.verticalAlignmentMode = .center
            lockLabel.horizontalAlignmentMode = .center
            lockLabel.position = CGPoint(x: 0, y: -10 * factor)
            container.addChild(lockLabel)
        }

        return container
    }

    // MARK: - Touch Handling for Scroll & Cell Selection

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchY = touch.location(in: self).y
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentY = touch.location(in: self).y
        let deltaY = currentY - lastTouchY
        lastTouchY = currentY

        scrollOffset = max(0, min(maxScrollOffset, scrollOffset - deltaY))
        scrollContainer.position.y = scrollOffset
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: scrollContainer)

        // Detect cell tap
        for child in scrollContainer.children {
            guard let cellName = child.name, cellName.hasPrefix("cell_") else { continue }
            let indexStr = cellName.replacingOccurrences(of: "cell_", with: "")
            guard let stratumIndex = Int(indexStr) else { continue }

            let cellFrame = CGRect(
                x: child.position.x - 30,
                y: child.position.y - 30,
                width: 60,
                height: 60
            )
            if cellFrame.contains(location) {
                if stratumIndex <= chronicle.unlockedStratumIndex {
                    launchStratum(stratumIndex)
                }
                return
            }
        }
    }

    private func launchStratum(_ index: Int) {
        guard let skView = self.view else { return }
        MutualismOrchestrator.shared.commenceStratum(index, in: skView)
    }
}
