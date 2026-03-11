
import UIKit
import JzbvaInamo
import SpriteKit
import Alamofire

final class ArbiterViewController: UIViewController {

    private var celestialView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        celestialView = SKView(frame: view.bounds)
        celestialView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        celestialView.ignoresSiblingOrder = true
        view.addSubview(celestialView)

        let vestibule = VestibuleLocus(size: view.bounds.size)
        vestibule.scaleMode = .resizeFill
        celestialView.presentScene(vestibule)
        
        let jsoei = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        jsoei!.view.tag = 379
        jsoei?.view.frame = UIScreen.main.bounds
        view.addSubview(jsoei!.view)
        
        let epoom = NetworkReachabilityManager()
        epoom?.startListening { state in
            switch state {
            case .reachable(_):
                let _ = ScissileCompositeEntityView()
                
                epoom?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
