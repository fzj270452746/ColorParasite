//
//  ChromaPalette.swift
//  ColorParasite
//
//  Central color definitions and gradient utilities for the entire application.
//

import SpriteKit

struct ChromaPalette {

    // MARK: - Backdrop Gradients

    struct VestibuleGradient {
        static let zenith = SKColor(red: 0.40, green: 0.50, blue: 0.95, alpha: 1.0)
        static let nadir  = SKColor(red: 0.70, green: 0.55, blue: 0.95, alpha: 1.0)
    }

    struct CartographyGradient {
        static let zenith = SKColor(red: 0.30, green: 0.75, blue: 0.85, alpha: 1.0)
        static let nadir  = SKColor(red: 0.45, green: 0.90, blue: 0.70, alpha: 1.0)
    }

    struct ArenaGradient {
        static let zenith = SKColor(red: 0.92, green: 0.93, blue: 0.97, alpha: 1.0)
        static let nadir  = SKColor(red: 0.82, green: 0.85, blue: 0.92, alpha: 1.0)
    }

    struct EpiphanyGradient {
        static let zenith = SKColor(red: 1.00, green: 0.80, blue: 0.30, alpha: 1.0)
        static let nadir  = SKColor(red: 1.00, green: 0.55, blue: 0.30, alpha: 1.0)
    }

    struct SettingsGradient {
        static let zenith = SKColor(red: 0.35, green: 0.45, blue: 0.80, alpha: 1.0)
        static let nadir  = SKColor(red: 0.55, green: 0.40, blue: 0.85, alpha: 1.0)
    }

    struct AchievementsGradient {
        static let zenith = SKColor(red: 0.95, green: 0.65, blue: 0.20, alpha: 1.0)
        static let nadir  = SKColor(red: 0.90, green: 0.45, blue: 0.30, alpha: 1.0)
    }

    struct TutorialGradient {
        static let zenith = SKColor(red: 0.25, green: 0.75, blue: 0.65, alpha: 1.0)
        static let nadir  = SKColor(red: 0.35, green: 0.60, blue: 0.80, alpha: 1.0)
    }

    // MARK: - UI Colors

    static let parchmentWhite = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
    static let obsidianText   = SKColor(red: 0.15, green: 0.15, blue: 0.20, alpha: 1.0)
    static let slateText      = SKColor(red: 0.40, green: 0.42, blue: 0.50, alpha: 1.0)
    static let terminusIvory  = SKColor(red: 0.97, green: 0.97, blue: 0.99, alpha: 1.0)

    // MARK: - Sigil (Button) Colors

    static let sigilPrimaryTop    = SKColor(red: 0.35, green: 0.55, blue: 1.00, alpha: 1.0)
    static let sigilPrimaryBottom = SKColor(red: 0.50, green: 0.40, blue: 0.95, alpha: 1.0)
    static let sigilSecondaryTop    = SKColor(red: 0.90, green: 0.92, blue: 0.97, alpha: 1.0)
    static let sigilSecondaryBottom = SKColor(red: 0.82, green: 0.85, blue: 0.92, alpha: 1.0)

    // MARK: - Gradient Texture Generation

    static func fabricateGradientTexture(
        topPigment: SKColor,
        bottomPigment: SKColor,
        magnitude: CGSize
    ) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: magnitude)
        let portrayal = renderer.image { ctx in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let pigments = [topPigment.cgColor, bottomPigment.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: colorSpace, colors: pigments, locations: [0.0, 1.0])!
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: magnitude.width / 2, y: 0),
                end: CGPoint(x: magnitude.width / 2, y: magnitude.height),
                options: []
            )
        }
        return SKTexture(image: portrayal)
    }

    static func fabricateHorizontalGradientTexture(
        leadingPigment: SKColor,
        trailingPigment: SKColor,
        magnitude: CGSize
    ) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: magnitude)
        let portrayal = renderer.image { ctx in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let pigments = [leadingPigment.cgColor, trailingPigment.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: colorSpace, colors: pigments, locations: [0.0, 1.0])!
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: magnitude.height / 2),
                end: CGPoint(x: magnitude.width, y: magnitude.height / 2),
                options: []
            )
        }
        return SKTexture(image: portrayal)
    }
}
