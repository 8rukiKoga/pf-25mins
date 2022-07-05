import UIKit

class MyUINavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲージョンアイテムの文字色
        UINavigationBar.appearance().tintColor = UIColor.white
    }
}
