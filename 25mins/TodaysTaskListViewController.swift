import UIKit

var taskList = [String]()


class TodaysTaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ganbariLabel: UILabel!
    
    //表示するcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TaskCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        TaskCell.textLabel!.text = taskList[indexPath.row]
        return TaskCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "TaskList") != nil {
            taskList = UserDefaults.standard.object(forKey: "TaskList") as! [String]
        }
        
        if taskList.count % 2 == 0 {
            ganbariLabel.text = String("これまで\(taskList.count / 2)時間がんばりました！")
        } else {
            ganbariLabel.text = String("これまで\(taskList.count / 2).5時間がんばりました！")
        }
    }
    
    @IBAction func closeTaskList(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            // 削除した内容を保存
            UserDefaults.standard.set(taskList, forKey: "TaskList")
        }
    }
}
