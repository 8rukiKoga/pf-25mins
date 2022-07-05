import UIKit

class FirstViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showTasks(_ sender: Any) {
        self.performSegue(withIdentifier: "toList", sender: nil)
    }
}
