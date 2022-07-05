import UIKit


class SettingTaskViewController: UIViewController {
    @IBOutlet weak var inputTaskName: UITextField!
    @IBOutlet weak var setTaskName: UIButton!
    
    let bgTimer = backgroundTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTaskName.placeholder = "タスク名を入力してください"
        setTaskName.isEnabled = false
        inputTaskName.delegate = self
    }
    
    @IBAction func inputTaskName(_ sender: Any){
        if inputTaskName.text!.count < 1 {
            setTaskName.isEnabled = false
        } else {
            setTaskName.isEnabled = true
        }
    }
    
    @IBAction func setTaskName(_ sender: Any) {
        self.performSegue(withIdentifier: "toTimer", sender: nil)
        inputTaskName.text = ""
    }
    
    //BGTimerにテキストフィールドの値を送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimer" {
            let nextView = segue.destination as! backgroundTimer
            nextView.taskName = inputTaskName.text!
        }
    }
}

//リターンキーでキーボードを閉じる
extension SettingTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
