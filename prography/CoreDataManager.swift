//
//  CoreDataManager.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import CoreData
import Foundation

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveData(movieID: Int, movieImage: Data?, movieTitle: String?, rate: Int, comment: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Review", in: context) else { return }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(movieImage, forKey: "movieImage")
        object.setValue(movieTitle, forKey: "movieTitle")
        object.setValue(comment, forKey: "comment")
        object.setValue(Date.now, forKey: "date")
        object.setValue(movieID, forKey: "movieID")
        object.setValue(rate, forKey: "rate")
        do {
            try context.save()
            print("리뷰 저장 완료")
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func fetchReviews() -> [Review]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Review")
        
        do {
            guard let reviews = try context.fetch(fetchRequest) as? [Review] else {
                return nil
            }
            return reviews
        } catch {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteData(movieID: Int) {
        // fetchRequest로 데이터를 검색
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %d", Int64(movieID)) // 조건 설정 (여기서 'name'은 엔티티의 속성)
        
        do {
            // 데이터 가져오기
            let results = try context.fetch(fetchRequest)
            
            // 데이터가 있으면 삭제
            for object in results {
                context.delete(object)
            }
            
            // 변경사항 저장
            try context.save()
            print("데이터 삭제 성공")
            
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
    
}
