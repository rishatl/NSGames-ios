//
//  CoreDataService.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.05.2022
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    var mainContext: NSManagedObjectContext { get }

    func deleteAll()

    func addOffer(_ offer: Offer)
    func deleteOffer(_ offer: Offer)
    func fetchOffers(completion: @escaping (([Offer]) -> Void))

    func saveAds(_ ads: [AdTableViewCellConfig])
    func deleteAd(_ ad: AdTableViewCellConfig)
    func fetchAds(completion: @escaping (([AdTableViewCellConfig]) -> Void))
}

final class CoreDataService: CoreDataServiceProtocol {

    static let offerDataModelName = "NSGames"

    private let dataModelName: String

    var didUpdateDataBase: ((CoreDataService) -> Void)?

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        storeContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            if context.hasChanges {
                do {
                    try self.performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }

    func addOffer(_ offer: Offer) {
        performSave { context in
            let fetchRequest: NSFetchRequest<OfferDB> = OfferDB.fetchRequest()
                let predicate = NSPredicate(format: "id == %i", offer.id)
            fetchRequest.predicate = predicate
            do {
                let offerDB = try context.fetch(fetchRequest)
                if offerDB.isEmpty {
                    _ = OfferDB(offer: offer, context: context)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteOffer(_ offer: Offer) {
        performSave { context in
            let fetchRequest: NSFetchRequest<OfferDB> = OfferDB.fetchRequest()
            let predicate = NSPredicate(format: "id == %i", offer.id)
            fetchRequest.predicate = predicate
            do {
                let offers = try context.fetch(fetchRequest)
                guard let offerToDelete = offers.first else { return }
                context.delete(offerToDelete)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchOffers(completion: @escaping (([Offer]) -> Void)) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var result = [Offer]()
            let fetch: NSFetchRequest<OfferDB> = OfferDB.fetchRequest()
            if let array = try? self?.mainContext.fetch(fetch) {
                result = array.map({ Offer(id: Int($0.id),
                                           username: $0.username,
                                           price: $0.price,
                                           tradeListCount: Int($0.tradeCount),
                                           description: $0.text,
                                           chatId: $0.chatId) })
            }
            DispatchQueue.main.async {
                return completion(result)
            }
        }
    }

    func saveAds(_ ads: [AdTableViewCellConfig]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            for ad in ads {
                self?.performSave { context in
                    let fetchRequest: NSFetchRequest<AdDb> = AdDb.fetchRequest()
                        let predicate = NSPredicate(format: "id == %i", ad.id)
                    fetchRequest.predicate = predicate
                    do {
                        let ads = try context.fetch(fetchRequest)
                        if ads.isEmpty {
                            _ = AdDb(ad: ad, context: context)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func deleteAd(_ ad: AdTableViewCellConfig) {
        performSave { context in
            let fetchRequest: NSFetchRequest<AdDb> = AdDb.fetchRequest()
            let predicate = NSPredicate(format: "id == %i", ad.id)
            fetchRequest.predicate = predicate
            do {
                let ads = try context.fetch(fetchRequest)
                guard let adToDelete = ads.first else { return }
                context.delete(adToDelete)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchAds(completion: @escaping (([AdTableViewCellConfig]) -> Void)) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var result = [AdTableViewCellConfig]()
            let fetch: NSFetchRequest<AdDb> = AdDb.fetchRequest()
            if let array = try? self?.mainContext.fetch(fetch) {
                result = array.map({ AdTableViewCellConfig(id: Int($0.id),
                                                           name: $0.name ?? String(),
                                                           numberOfOffers: Int($0.offersNumber),
                                                           photo: $0.photo ?? Data(),
                                                           views: Int($0.viewsNumber)) })
            }
            DispatchQueue.main.async {
                return completion(result)
            }
        }
    }

    func deleteAll() {
        performSave { context in
            let adRequest = NSBatchDeleteRequest(fetchRequest: AdDb.fetchRequest())
            let offerRequest = NSBatchDeleteRequest(fetchRequest: OfferDB.fetchRequest())
            do {
                _ = try context.execute(adRequest)
                _ = try context.execute(offerRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
