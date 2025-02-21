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
    
    func registerReview(movieID: Int, movieImage: Data?, movieTitle: String?, rate: Int, comment: String) {
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %d", movieID)
        
        do {
            // 데이터 가져오기
            let results = try context.fetch(fetchRequest)
            
            if let existingReview = results.first {
                // 기존 데이터가 있다면 덮어쓰기
                existingReview.movieImage = movieImage
                existingReview.movieTitle = movieTitle
                existingReview.comment = comment
                existingReview.date = Date.now
                existingReview.rate = Int64(rate)
                print("기존 리뷰 덮어쓰기 완료")
            } else {
                // 기존 데이터가 없다면 새로운 데이터 추가
                guard let entity = NSEntityDescription.entity(forEntityName: "Review", in: context) else { return }
                let newReview = NSManagedObject(entity: entity, insertInto: context)
                newReview.setValue(movieImage, forKey: "movieImage")
                newReview.setValue(movieTitle, forKey: "movieTitle")
                newReview.setValue(comment, forKey: "comment")
                newReview.setValue(Date.now, forKey: "date")
                newReview.setValue(movieID, forKey: "movieID")
                newReview.setValue(rate, forKey: "rate")
                print("새로운 리뷰 저장 완료")
            }
            
            // 변경사항 저장
            try context.save()
            print("리뷰 저장 완료")
            
        } catch {
            // 에러 처리
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
    
    func deleteReview(movieID: Int) {
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
