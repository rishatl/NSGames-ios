//
//  FavoriteOffersViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.05.2022
//

import Foundation

protocol FavoriteOffersViewModelProtocol {
    var items: Observable<[Offer]> { get set }

    func setup()
    func goToChat(id: Int)
    func showTradeList(id: Int)
    func delete(index: Int)
}

class FavoriteOffersViewModel: FavoriteOffersViewModelProtocol {
    var items: Observable<[Offer]> = Observable([])

    private let coreDataService: CoreDataServiceProtocol
    private let coordinator: ProfileCoordinatorProtocol

    init(coreDataService: CoreDataServiceProtocol,
         coordinator: ProfileCoordinatorProtocol) {
        self.coordinator = coordinator
        self.coreDataService = coreDataService
    }

    func setup() {
        coreDataService.fetchOffers { [weak self] result in
            self?.items.value = result
        }
    }

    func goToChat(id: Int) {
        if let data = items.value.first(where: { $0.id == id }) {
            coordinator.goToChat(messageId: data.chatId, username: data.username)
        }
    }

    func delete(index: Int) {
        let deletedOffer = items.value[index]
        items.value.remove(at: index)
        coreDataService.deleteOffer(deletedOffer)
    }

    func showTradeList(id: Int) {
        if let id = items.value.first(where: { $0.id == id })?.id {
            coordinator.goToTradeList(id: id)
        }
    }
}
