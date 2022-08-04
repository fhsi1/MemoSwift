//
//  ComposeViewController.swift
//  MemoSwift
//
//  Created by Yujean Cho on 2022/08/03.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // 실제 메모를 입력한 경우에만 처리
        guard let memo = memoTextView.text, memo.count > 0 else {
            // 메모를 작성하지 않은 경우 경고창
            alert(message: "Please enter a memo.")
            return
        }
        
        // 메모를 정상적으로 입력했을 때
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController {
    // Notification 이름 설정
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
