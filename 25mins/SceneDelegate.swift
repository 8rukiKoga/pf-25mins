import UIKit

//デリゲート用の変数、関数
protocol backgroundTimerDelegate: AnyObject {
    func setCurrentTimer(_ elapsedTime:Int)
    func deleteTimer()
    func checkBackground()
    var timerIsBackground:Bool { set get }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    weak var delegate: backgroundTimerDelegate?
    let ud = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    //アプリ画面に復帰した時
    func sceneDidBecomeActive(_ scene: UIScene) {
        if delegate?.timerIsBackground == true {
            let calender = Calendar(identifier: .gregorian)
            let date1 = ud.value(forKey: "date1") as! Date
            let date2 = Date()
            let elapsedTime = calender.dateComponents([.second], from: date1, to: date2).second!
            delegate?.setCurrentTimer(elapsedTime)
        }
    }

    //アプリ画面から離れる時（ホームボタン押下、スリープ）
    func sceneWillResignActive(_ scene: UIScene) {
        ud.set(Date(), forKey: "date1")
        delegate?.checkBackground()
        delegate?.deleteTimer()
    }
}
