//
//  DetailViewModelProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import Foundation

protocol DetailViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var items: Observable<[Offer]> { get set }
    var error: Observable<String?> { get set }

    func setup()
    func goToChat(id: Int)
    func showTradeList(id: Int)
    func saveFavorite(index: Int)
}

class DetailViewModel: DetailViewModelProtocol {
    var items: Observable<[Offer]> = Observable([])
    var error: Observable<String?> = Observable(nil)
    let id: Int
    let title: String

    private let service: DetailOfferViewServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private let coordinator: ProfileCoordinatorProtocol

    init(service: DetailOfferViewServiceProtocol,
         coreDataService: CoreDataServiceProtocol,
         coordinator: ProfileCoordinatorProtocol,
         id: Int,
         title: String) {
        self.service = service
        self.coordinator = coordinator
        self.coreDataService = coreDataService
        self.id = id
        self.title = title
    }

    func saveFavorite(index: Int) {
        coreDataService.addOffer(self.items.value[index])
    }

    func setup() {
        service.getOffers(id: id) { [weak self] result in
            switch result {
            case .success(let offers):
                self?.items.value = offers

            case .failure:
                self?.error.value = L10n.inetError
            }
        }
    }

    func goToChat(id: Int) {
        if let data = items.value.first(where: { $0.id == id }) {
            coordinator.goToChat(messageId: data.chatId, username: data.username)
        }
    }

    func showTradeList(id: Int) {
        if let id = items.value.first(where: { $0.id == id })?.id {
            coordinator.goToTradeList(id: id)
        }
    }
}
