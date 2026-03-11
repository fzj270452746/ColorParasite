//
//  MutualismOrchestrator.swift
//  ColorParasite
//
//  Central game state manager coordinating scene transitions and global state.
//

import SpriteKit

final class MutualismOrchestrator {

    static let shared = MutualismOrchestrator()

    private(set) var currentStratumIndex: Int = 1
    private(set) var chronicle: ChronicleRecord

    static let totalStrata: Int = 100

    private init() {
        chronicle = ChronicleVault.shared.excavate()
    }

    func refreshChronicle() {
        chronicle = ChronicleVault.shared.excavate()
    }

    // MARK: - Scene Navigation

    func commenceStratum(_ index: Int, in skView: SKView) {
        currentStratumIndex = index
        let arena = ChrysalisArena(size: skView.bounds.size)
        arena.scaleMode = .resizeFill
        arena.stratumIndex = index
        let transition = SKTransition.fade(withDuration: 0.4)
        skView.presentScene(arena, transition: transition)
    }

    func proceedToNextStratum(in skView: SKView) {
        let nextIndex = currentStratumIndex + 1
        if nextIndex <= MutualismOrchestrator.totalStrata {
            commenceStratum(nextIndex, in: skView)
        } else {
            retreatToCartography(in: skView)
        }
    }

    func retreatToVestibule(in skView: SKView) {
        let vestibule = VestibuleLocus(size: skView.bounds.size)
        vestibule.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.3)
        skView.presentScene(vestibule, transition: transition)
    }

    func retreatToCartography(in skView: SKView) {
        let cartography = CartographyLocus(size: skView.bounds.size)
        cartography.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.3)
        skView.presentScene(cartography, transition: transition)
    }

    func navigateToSettings(in skView: SKView) {
        let settings = SettingsLocus(size: skView.bounds.size)
        settings.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.3)
        skView.presentScene(settings, transition: transition)
    }

    func navigateToAchievements(in skView: SKView) {
        let achievements = AchievementsLocus(size: skView.bounds.size)
        achievements.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.3)
        skView.presentScene(achievements, transition: transition)
    }

    func navigateToTutorial(in skView: SKView) {
        let tutorial = TutorialLocus(size: skView.bounds.size)
        tutorial.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.3)
        skView.presentScene(tutorial, transition: transition)
    }

    func purgeAllProgress(in skView: SKView) {
        ChronicleVault.shared.purgeAllRecords()
        refreshChronicle()
        retreatToVestibule(in: skView)
    }

    func exhibitEpiphany(laurel: LaurelGrade, cadenceUsed: Int, in skView: SKView) {
        ChronicleVault.shared.inscribeLaurel(laurel, forStratum: currentStratumIndex)
        ChronicleVault.shared.advanceUnlocked(to: currentStratumIndex + 1)
        refreshChronicle()

        let epiphany = EpiphanyLocus(size: skView.bounds.size)
        epiphany.scaleMode = .resizeFill
        epiphany.stratumIndex = currentStratumIndex
        epiphany.awardedLaurel = laurel
        epiphany.cadenceExpended = cadenceUsed
        let transition = SKTransition.fade(withDuration: 0.4)
        skView.presentScene(epiphany, transition: transition)
    }
}
