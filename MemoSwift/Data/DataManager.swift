//
//  DataManager.swift
//  MemoSwift
//
//  Created by Yujean Cho on 2022/08/04.
//

import Foundation
import CoreData

class DataManager {
    // singleton, 앱 전체에서 하나의 인스턴스 공유
    // 공유 인스턴스를 저장할 type property
    static let shared = DataManager()
    
    // 기본 생성자
    private init() {
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 메모를 DB 에서 읽어온다.
    var memoList = [Memo]()
    func fetchMemo() {
        // fetchRequest
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        // 날짜 내림차순으로 정렬
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // fetchRequest 실행, 데이터 가져오기
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MemoSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
