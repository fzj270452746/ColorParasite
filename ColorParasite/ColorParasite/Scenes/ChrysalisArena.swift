//
//  ChrysalisArena.swift
//  ColorParasite
//
//  Core gameplay scene where the parasite navigates host orbs.
//

import SpriteKit

enum ArenaPhase {
    case preparing
    case awaiting
    case translocating
    case shackled
    case triumphant
    case defeated
}

final class ChrysalisArena: SKScene {

    var stratumIndex: Int = 1

    private var backdrop: GradientBackdrop!
    private let latticeLayer = SKNode()
    private var diadem: DiademOverlay!
    private var symbiont: SymbiontNode!

    private var activeCorpuscles: [CorpuscleNode] = []
    private var blueprint: StratumBlueprint!
    private var currentCadence: Int = 0
    private var phase: ArenaPhase = .preparing
    private var isShackledNext: Bool = false
    private var colonizedIdentifiers: Set<String> = []

    private var safeAreaPadding: UIEdgeInsets = .zero

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = .white
        safeAreaPadding = view.safeAreaInsets

        assembleBackdrop()
        loadBlueprint()
        assembleLattice()
        assembleDiadem()

        phase = .awaiting
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if backdrop != nil {
            backdrop.recalibrate(
                to: size,
                zenithPigment: ChromaPalette.ArenaGradient.zenith,
                nadirPigment: ChromaPalette.ArenaGradient.nadir
            )
            backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }

    // MARK: - Setup

    private func assembleBackdrop() {
        backdrop = GradientBackdrop(
            zenithPigment: ChromaPalette.ArenaGradient.zenith,
            nadirPigment: ChromaPalette.ArenaGradient.nadir,
            magnitude: size
        )
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backdrop)
    }

    private func loadBlueprint() {
        blueprint = StrataCompendium.shared.blueprint(for: stratumIndex)
    }

    private func assembleLattice() {
        latticeLayer.zPosition = 0
        addChild(latticeLayer)

        let gridSpec = (columns: blueprint.latticeColumns, rows: blueprint.latticeRows)
        let radius = ViewportCalibrator.corpuscleRadius(gridSpec: gridSpec, sceneMagnitude: size)

        // Draw connection lines between adjacent orbs
        assembleConnectionLines(gridSpec: gridSpec)

        // Place all corpuscles
        for spec in blueprint.corpuscles {
            let scenePos = ViewportCalibrator.sceneCoordinate(
                latticePoint: spec.latticePosition,
                gridSpec: gridSpec,
                sceneMagnitude: size,
                safeAreaPadding: safeAreaPadding
            )

            let corpuscle = fabricateCorpuscle(from: spec, radius: radius)
            corpuscle.position = scenePos
            latticeLayer.addChild(corpuscle)
            activeCorpuscles.append(corpuscle)

            // Configure nomadic behavior if applicable
            if let nomadic = corpuscle as? NomadicNode {
                nomadic.configureNomadicBehavior(
                    sceneMagnitude: size,
                    gridSpec: gridSpec,
                    safeAreaPadding: safeAreaPadding
                )
            }
        }

        // Place symbiont at origin
        let originSpec = blueprint.corpuscles.first { $0.identifier == blueprint.originIdentifier }!
        let originPos = ViewportCalibrator.sceneCoordinate(
            latticePoint: originSpec.latticePosition,
            gridSpec: gridSpec,
            sceneMagnitude: size,
            safeAreaPadding: safeAreaPadding
        )

        symbiont = SymbiontNode(initialChroma: blueprint.initialChroma, radius: radius)
        symbiont.position = originPos
        latticeLayer.addChild(symbiont)

        // Mark origin as colonized
        if let originNode = activeCorpuscles.first(where: { $0.spec.identifier == blueprint.originIdentifier }) {
            originNode.isColonized = true
            originNode.alpha = 0.4
            colonizedIdentifiers.insert(blueprint.originIdentifier)
        }
    }

    private func fabricateCorpuscle(from spec: CorpuscleSpec, radius: CGFloat) -> CorpuscleNode {
        switch spec.variant {
        case .terminus:
            return TerminusNode(spec: spec, radius: radius)
        case .kaleidoscope:
            return KaleidoscopeNode(spec: spec, radius: radius)
        case .shackle:
            return ShackleNode(spec: spec, radius: radius)
        case .wormhole:
            return WormholeNode(spec: spec, radius: radius)
        case .nomadic:
            return NomadicNode(spec: spec, radius: radius)
        case .standard, .origin:
            return VesicleNode(spec: spec, radius: radius)
        }
    }

    private func assembleConnectionLines(gridSpec: (columns: Int, rows: Int)) {
        // Draw subtle lines between orbs that are adjacent in the lattice
        let specs = blueprint.corpuscles
        for i in 0..<specs.count {
            for j in (i + 1)..<specs.count {
                let posA = specs[i].latticePosition
                let posB = specs[j].latticePosition
                let dx = abs(posA.x - posB.x)
                let dy = abs(posA.y - posB.y)

                // Connect if adjacent (within 1.5 grid units)
                let distance = sqrt(dx * dx + dy * dy)
                if distance <= 1.6 {
                    let screenA = ViewportCalibrator.sceneCoordinate(
                        latticePoint: posA, gridSpec: gridSpec,
                        sceneMagnitude: size, safeAreaPadding: safeAreaPadding
                    )
                    let screenB = ViewportCalibrator.sceneCoordinate(
                        latticePoint: posB, gridSpec: gridSpec,
                        sceneMagnitude: size, safeAreaPadding: safeAreaPadding
                    )
                    let linePath = CGMutablePath()
                    linePath.move(to: screenA)
                    linePath.addLine(to: screenB)
                    let lineNode = SKShapeNode(path: linePath)
                    lineNode.strokeColor = SKColor(red: 0.7, green: 0.72, blue: 0.78, alpha: 0.3)
                    lineNode.lineWidth = 1.5
                    lineNode.zPosition = -1
                    latticeLayer.addChild(lineNode)
                }
            }
        }
    }

    private func assembleDiadem() {
        diadem = DiademOverlay(sceneMagnitude: size, safeAreaPadding: safeAreaPadding)
        addChild(diadem)

        diadem.refreshStratumBadge(index: stratumIndex)
        diadem.refreshCadenceCounter(current: 0, maximum: blueprint.maxCadence)

        diadem.onRetreatActivated = { [weak self] in
            self?.confirmRetreat()
        }
        diadem.onResetActivated = { [weak self] in
            self?.resetArena()
        }
    }

    // MARK: - Touch Handling

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard phase == .awaiting || phase == .shackled else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: latticeLayer)

        for corpuscle in activeCorpuscles where !corpuscle.isColonized {
            if corpuscle.hitTestEnvelope(at: location) {
                attemptColonization(of: corpuscle)
                return
            }
        }
    }

    // MARK: - Colonization Logic

    private func attemptColonization(of target: CorpuscleNode) {
        // If shackled, must match current color
        if isShackledNext {
            if let targetChroma = target.spec.chroma, targetChroma != symbiont.currentChroma {
                // Rejection — wrong color
                target.run(KinesisFactory.rejectionTremor())
                symbiont.run(KinesisFactory.shackleVibration())
                return
            }
            isShackledNext = false
        }

        // Same color cannot be consumed (skip for terminus/kaleidoscope/wormhole which have special rules)
        if target.spec.variant == .standard || target.spec.variant == .origin || target.spec.variant == .shackle || target.spec.variant == .nomadic {
            if let targetChroma = target.spec.chroma, targetChroma == symbiont.currentChroma {
                target.run(KinesisFactory.rejectionTremor())
                return
            }
        }

        phase = .translocating
        currentCadence += 1
        diadem.refreshCadenceCounter(current: currentCadence, maximum: blueprint.maxCadence)

        let destination = target.position

        symbiont.translocate(to: destination, duration: 0.35) { [weak self] in
            guard let self = self else { return }
            self.executeColonization(of: target)
        }
    }

    private func executeColonization(of target: CorpuscleNode) {
        // Determine new color
        var newChroma: ChromaType = symbiont.currentChroma

        if let kNode = target as? KaleidoscopeNode {
            // Kaleidoscope: random color
            newChroma = kNode.resolveRandomChroma()
        } else if target.spec.variant == .terminus {
            // Terminus: keep current color, trigger win
        } else if let targetChroma = target.spec.chroma {
            newChroma = targetChroma
        }

        // Update symbiont color
        symbiont.morphChroma(to: newChroma)

        // Mark target as colonized
        target.executeColonizationKinesis { }
        colonizedIdentifiers.insert(target.spec.identifier)

        // Handle special orb effects
        handleSpecialEffects(of: target) { [weak self] in
            guard let self = self else { return }

            // Check win condition
            if target.spec.identifier == self.blueprint.terminusIdentifier {
                self.triggerTriumph()
                return
            }

            // Check lose condition
            if self.currentCadence >= self.blueprint.maxCadence {
                self.triggerDefeat()
                return
            }

            // If this was a shackle orb, set flag
            if target.spec.variant == .shackle {
                self.isShackledNext = true
                self.phase = .shackled
            } else {
                self.phase = .awaiting
            }
        }
    }

    private func handleSpecialEffects(of target: CorpuscleNode, completion: @escaping () -> Void) {
        if let wormhole = target as? WormholeNode,
           let partnerId = wormhole.partnerIdentifier,
           let partner = activeCorpuscles.first(where: { $0.spec.identifier == partnerId && !$0.isColonized }) {
            // Teleport to partner
            let teleportAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0, duration: 0.15),
                SKAction.move(to: partner.position, duration: 0),
                SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            ])
            symbiont.run(teleportAction) {
                // Don't mark partner as colonized — player can colonize from there
                completion()
            }
            return
        }

        completion()
    }

    // MARK: - Win / Lose

    private func triggerTriumph() {
        phase = .triumphant

        let laurel = evaluateLaurel()

        symbiont.run(KinesisFactory.triumphantBurst())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self, let skView = self.view else { return }
            MutualismOrchestrator.shared.exhibitEpiphany(
                laurel: laurel,
                cadenceUsed: self.currentCadence,
                in: skView
            )
        }
    }

    private func triggerDefeat() {
        phase = .defeated

        let manifesto = ManifestoNode(
            heading: "Out of Steps",
            proclamation: "You've exhausted all available moves.\nWould you like to try again?",
            edicts: [
                ("Retry", { [weak self] in self?.resetArena() }),
                ("Retreat", { [weak self] in
                    guard let self = self, let skView = self.view else { return }
                    MutualismOrchestrator.shared.retreatToCartography(in: skView)
                })
            ],
            sceneMagnitude: size
        )
        manifesto.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(manifesto)
    }

    private func evaluateLaurel() -> LaurelGrade {
        if currentCadence <= blueprint.optimalCadence {
            return .gold
        } else if currentCadence <= blueprint.optimalCadence + 2 {
            return .silver
        } else {
            return .bronze
        }
    }

    // MARK: - Reset & Navigation

    private func resetArena() {
        // Remove all game nodes
        latticeLayer.removeAllChildren()
        latticeLayer.removeFromParent()
        activeCorpuscles.removeAll()
        colonizedIdentifiers.removeAll()
        symbiont = nil

        currentCadence = 0
        isShackledNext = false
        phase = .preparing

        diadem.removeFromParent()

        // Rebuild
        assembleLattice()
        assembleDiadem()
        phase = .awaiting
    }

    private func confirmRetreat() {
        let manifesto = ManifestoNode(
            heading: "Leave Level?",
            proclamation: "Your progress on this level will be lost.",
            edicts: [
                ("Leave", { [weak self] in
                    guard let self = self, let skView = self.view else { return }
                    MutualismOrchestrator.shared.retreatToCartography(in: skView)
                }),
                ("Stay", { })
            ],
            sceneMagnitude: size
        )
        manifesto.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(manifesto)
    }
}
