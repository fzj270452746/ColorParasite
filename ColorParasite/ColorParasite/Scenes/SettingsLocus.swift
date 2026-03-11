//
//  SettingsLocus.swift
//  ColorParasite
//
//  Settings scene with sound, music, and vibration toggles.
//

import SpriteKit

final class SettingsLocus: SKScene {

    private var backdrop: GradientBackdrop!

    override func didMove(to view: SKView) {
        backgroundColor = .white
        assembleBackdrop()
        assembleHeader()
        assembleToggles()
        assembleBackButton()
    }

    // MARK: - Assembly

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.SettingsGradient.zenith,
            nadirPigment: ChromaPalette.SettingsGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func assembleHeader() {
        let factor = ViewportCalibrator.proportionFactor(for: size)

        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 32 * factor
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(titleLabel)
    }

    private func assembleToggles() {
        let factor = ViewportCalibrator.proportionFactor(for: size)
        let settings = SettingsVault.shared
        let centerX = size.width / 2
        let startY = size.height * 0.65

        let soundToggle = ToggleSigilNode(caption: "Sound Effects", isOn: settings.isSoundEnabled, factor: factor)
        soundToggle.position = CGPoint(x: centerX, y: startY)
        soundToggle.onToggled = { newValue in
            settings.isSoundEnabled = newValue
        }
        addChild(soundToggle)

        let musicToggle = ToggleSigilNode(caption: "Music", isOn: settings.isMusicEnabled, factor: factor)
        musicToggle.position = CGPoint(x: centerX, y: startY - 70 * factor)
        musicToggle.onToggled = { newValue in
            settings.isMusicEnabled = newValue
        }
        addChild(musicToggle)

        let vibrationToggle = ToggleSigilNode(caption: "Vibration", isOn: settings.isVibrationEnabled, factor: factor)
        vibrationToggle.position = CGPoint(x: centerX, y: startY - 140 * factor)
        vibrationToggle.onToggled = { newValue in
            settings.isVibrationEnabled = newValue
        }
        addChild(vibrationToggle)
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
