//
//  GradientBackdrop.swift
//  ColorParasite
//
//  Renders a full-screen gradient background sprite for any scene.
//

import SpriteKit

final class GradientBackdrop: SKSpriteNode {

    init(zenithPigment: SKColor, nadirPigment: SKColor, magnitude: CGSize) {
        let gradientTexture = ChromaPalette.fabricateGradientTexture(
            topPigment: zenithPigment,
            bottomPigment: nadirPigment,
            magnitude: magnitude
        )
        super.init(texture: gradientTexture, color: .clear, size: magnitude)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = -10
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func recalibrate(to newMagnitude: CGSize, zenithPigment: SKColor, nadirPigment: SKColor) {
        let newTexture = ChromaPalette.fabricateGradientTexture(
            topPigment: zenithPigment,
            bottomPigment: nadirPigment,
            magnitude: newMagnitude
        )
        self.texture = newTexture
        self.size = newMagnitude
    }
}
