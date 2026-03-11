//
//  ViewportCalibrator.swift
//  ColorParasite
//
//  Screen adaptation utilities for dynamic layout across device sizes.
//

import SpriteKit

struct ViewportCalibrator {

    static let canonicalWidth: CGFloat = 375.0
    static let canonicalHeight: CGFloat = 667.0

    static func proportionFactor(for sceneMagnitude: CGSize) -> CGFloat {
        let horizontalRatio = sceneMagnitude.width / canonicalWidth
        let verticalRatio = sceneMagnitude.height / canonicalHeight
        return min(horizontalRatio, verticalRatio)
    }

    static func sceneCoordinate(
        latticePoint: CGPoint,
        gridSpec: (columns: Int, rows: Int),
        sceneMagnitude: CGSize,
        safeAreaPadding: UIEdgeInsets = .zero
    ) -> CGPoint {
        let factor = proportionFactor(for: sceneMagnitude)

        let playableTop = safeAreaPadding.top + 80 * factor
        let playableBottom = safeAreaPadding.bottom + 80 * factor
        let playableHeight = sceneMagnitude.height - playableTop - playableBottom
        let playableWidth = sceneMagnitude.width - 40 * factor

        let cellWidth = playableWidth / CGFloat(max(gridSpec.columns, 1))
        let cellHeight = playableHeight / CGFloat(max(gridSpec.rows, 1))

        let originX = (sceneMagnitude.width - playableWidth) / 2.0 + cellWidth / 2.0
        let originY = sceneMagnitude.height - playableTop - cellHeight / 2.0

        let posX = originX + latticePoint.x * cellWidth
        let posY = originY - latticePoint.y * cellHeight

        return CGPoint(x: posX, y: posY)
    }

    static func corpuscleRadius(
        gridSpec: (columns: Int, rows: Int),
        sceneMagnitude: CGSize
    ) -> CGFloat {
        let factor = proportionFactor(for: sceneMagnitude)
        let baseRadius: CGFloat = 22.0

        let playableWidth = sceneMagnitude.width - 40 * factor
        let cellWidth = playableWidth / CGFloat(max(gridSpec.columns, 1))
        let maxRadiusByGrid = cellWidth * 0.38

        return min(baseRadius * factor, maxRadiusByGrid)
    }
}
