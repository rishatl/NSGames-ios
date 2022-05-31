//
//  ProfileViewModelProtocol.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import Foundation

protocol ProfileViewModelProtocol {
    var items: Observable<[AdTableViewCellConfig]> { get set }
    var userInfo: Observable <UserInfo?> { get set }
    var error: Observable<String?> { get set }

    func quit()
    func setup()
    func favorites()
    func deleteAd(index: Int)
    func didSelectItem(at: Int)
}

class ProfileViewModel: ProfileViewModelProtocol {
    var items: Observable<[AdTableViewCellConfig]> = Observable([])
    var userInfo: Observable<UserInfo?> = Observable(nil)
    var error: Observable<String?> = Observable(nil)

    private let coreDataService: CoreDataServiceProtocol
    private let service: ProfileViewServiceProtocol
    private let coordinator: ProfileCoordinatorProtocol

    init(service: ProfileViewServiceProtocol,
         coreDataService: CoreDataServiceProtocol,
         coordinator: ProfileCoordinatorProtocol) {
        self.service = service
        self.coreDataService = coreDataService
        self.coordinator = coordinator
    }

    func setup() {
        service.getUserInfo { [weak self] result in
            switch result {
            case .success(let data):
                self?.userInfo.value = data

            case .failure:
                self?.error.value = L10n.inetError
            }
        }

        service.getAds { [weak self] result in
            switch result {
            case .success(let data):
                self?.items.value = data
                self?.coreDataService.saveAds(data)

            case .failure:
                self?.error.value = L10n.inetError + L10n.cache
                self?.coreDataService.fetchAds { [weak self] result in
                    self?.items.value = result
                }
            }
        }
    }

    func quit() {
        service.logout { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.goToAuth()
                self?.coreDataService.deleteAll()

            case .failure:
                self?.error.value = L10n.logoutError
            }
        }
    }

    func didSelectItem(at index: Int) {
        let data = items.value[index]
        coordinator.goToDetailOfferView(id: data.id, name: data.name)
    }

    func favorites() {
        coordinator.goToFavorites()
    }

    func deleteAd(index: Int) {
        let deletedAd = items.value[index]
        items.value.remove(at: index)
        service.deleteAd(id: deletedAd.id) { [weak self] result in
            switch result {
            case .success:
                self?.coreDataService.deleteAd(deletedAd)

            case .failure:
                self?.items.value.insert(deletedAd, at: index)
            }
        }
    }
}
