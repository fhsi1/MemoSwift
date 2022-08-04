//
//  ComposeViewController.swift
//  MemoSwift
//
//  Created by Yujean Cho on 2022/08/03.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // 보기 화면에서 전달한 메모 저장 속성
    var editTarget: Memo?
    
    // 편집 이전의 메모내용 저장 속성
    var originalMemoContent: String?

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
        
        if let target = editTarget { // edit mode
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo) // newMemo mode
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        
        
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // editTarget 속성에 memo 가 저장되어 있다면 edit mode
        if let memo = editTarget {
            navigationItem.title = "edit"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationItem.title = "New MEMO"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate {
    // textView 에서 text 를 편집할 때마다 반복적으로 호출
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                // 기존 메모와 수정된 메모가 다르다면 true 가 저장된다.
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    // 기존의 메모와 다른 수정된 메모를 작성하던 도중 modal 을 pull down 할 때 호출
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to save the edited memo?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (action) in
            self?.save(action)
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.close(action)
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
    // Notification 이름 설정
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
