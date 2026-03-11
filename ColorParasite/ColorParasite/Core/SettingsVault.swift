//
//  SettingsVault.swift
//  ColorParasite
//
//  Persistent storage for user settings using UserDefaults.
//

import Foundation

final class SettingsVault {

    static let shared = SettingsVault()

    private let soundKey = "cp_sound_enabled"
    private let musicKey = "cp_music_enabled"
    private let vibrationKey = "cp_vibration_enabled"

    private init() {}

    var isSoundEnabled: Bool {
        get { UserDefaults.standard.object(forKey: soundKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: soundKey) }
    }

    var isMusicEnabled: Bool {
        get { UserDefaults.standard.object(forKey: musicKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: musicKey) }
    }

    var isVibrationEnabled: Bool {
        get { UserDefaults.standard.object(forKey: vibrationKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: vibrationKey) }
    }
}
