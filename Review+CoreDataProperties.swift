//
//  Review+CoreDataProperties.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var comment: String?
    @NSManaged public var movieID: Int64
    @NSManaged public var rate: Int64
    @NSManaged public var date: Date?
    @NSManaged public var movieImage: Data?
    @NSManaged public var movieTitle: String?

}

extension Review : Identifiable {

}
