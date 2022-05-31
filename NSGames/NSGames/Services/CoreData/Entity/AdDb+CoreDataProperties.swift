//
//  AdDb+CoreDataProperties.swift
//
//
//  Created by Nikita Sosyuk on 25.05.2021.
//
//

import Foundation
import CoreData

extension AdDb {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdDb> {
        return NSFetchRequest<AdDb>(entityName: "AdDb")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var offersNumber: Int64
    @NSManaged public var photo: Data?
    @NSManaged public var viewsNumber: Int64

    convenience init(ad: AdTableViewCellConfig, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int64(ad.id)
        self.name = ad.name
        self.offersNumber = Int64(ad.numberOfOffers)
        self.photo = ad.photo
        self.viewsNumber = Int64(ad.views)
    }
}
