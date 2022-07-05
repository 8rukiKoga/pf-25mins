import UIKit
import AVFoundation

class backgroundTimer: UIViewController,backgroundTimerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    var timerIsBackground = false
    var timer:Timer!
    var currentTime = 0
    
    var minutes = 25
    var seconds = 0
    
    //25分タイマーか5分タイマーかを見分ける変数の初期値を設定
    var status = 1
    
    //SetTaskVCから送られるテキストフィールドの値
    var taskName = ""
    
    var count60 = 0
    
    var player: AVAudioPlayer?
    var alarmPath = Bundle.main.bundleURL.appendingPathComponent("alarmSound.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        start.layer.masksToBounds = true
        start.layer.cornerRadius = start.bounds.width / 2
        
        stop.layer.masksToBounds = true
        stop.layer.cornerRadius = stop.bounds.width / 2
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                  return
              }
        sceneDelegate.delegate = self
    }
    
    @IBAction func start(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(advancedTime), userInfo: nil, repeats: true)
        start.isHidden = true
    }
    
    @IBAction func stop(_ sender: Any) {
        timer.invalidate()
        start.isHidden = false
    }
    
    func setUpTimer() {
        seconds = 0
        minutes = 25
        status += 1
        
        if seconds <= 9 {
            secondLabel.text = String("0\(seconds)")
        } else {
            secondLabel.text = String(seconds)
        }
        minuteLabel.text = String(minutes)
    }
    
    @objc func advancedTime() {
        seconds -= 1
        secondLabel.text = String(seconds)
        minuteLabel.text = String(minutes)
        
        if seconds < 0 {
            seconds = 59
            minutes -= 1
            secondLabel.text = String(seconds)
            minuteLabel.text = String(minutes)
        }
        
        if seconds <= 9 {
            secondLabel.text = String("0\(seconds)")
        }
        
        //作業もしくは休憩が終わった時の処理
        if minutes == 0 && seconds == 0 {
            playAlarm()
            
            //25→0になったときの処理
            if status % 2 == 1 {
                breakTime()
                taskList.append(taskName)
                UserDefaults.standard.set(taskList, forKey: "TaskList" )
                
            } else {
                setUpTimer()
            }
        }
        considerTimer()
    }
    
    func breakTime() {
        seconds = 0
        minutes = 5
        secondLabel.text = String("0\(seconds)")
        minuteLabel.text = String(minutes)
        status += 1
    }
    
    func playAlarm() {
        do {
            player = try AVAudioPlayer(contentsOf: alarmPath, fileTypeHint: nil)
            player?.numberOfLoops = 3
            player?.play()
        } catch {
            print(error)
        }
    }
    
    //25分タイマーか5分タイマーかを見分けるメソッド
    func considerTimer() {
        if status % 2 == 0 {
            statusLabel.text = String("休憩中です")
        }
        
        if status % 2 == 1 {
            statusLabel.text = String("作業中です")
        }
    }
    
    func checkBackground() {
        if let _ = timer {
            timerIsBackground = true
        }
    }
    
    func setCurrentTimer(_ elapsedTime:Int) {
        if start.isHidden == true {
            seconds -= elapsedTime
            
            if seconds <= -1 && minutes >= 1 {
                minutes -= 1
            }
            while seconds + 60 < 0 {
                seconds += 60
                count60 += 1
            }
            if minutes >= count60 {
                minutes -= count60
            }
            if seconds < 0 && count60 >= 1 {
                seconds += 60
            }
            if seconds >= -59 && seconds < 0 && minutes >= 1 {
                seconds += 60
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(advancedTime), userInfo: nil, repeats: true)
            
            if minutes <= 0 && seconds <= 0 {
                minutes = 0
                seconds = 1
            }
            
            count60 = 0
            secondLabel.text = String(seconds)
            minuteLabel.text = String(minutes)
        }
    }
    
    func deleteTimer() {
        if let _ = timer {
            timer.invalidate()
        }
    }
}
