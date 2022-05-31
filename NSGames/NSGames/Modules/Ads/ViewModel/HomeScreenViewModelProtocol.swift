//
//  HomeScreenViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import Foundation

protocol HomeScreenViewModelProtocol {
    var items: Observable<[AdCollectionViewCellConfig]> { get set }
    var error: Observable<String?> { get set }

    func getData(completion: (() -> Void)?)
    func searchAds(text: String)
    func likeAd(id: Int)
    func detailView(at: Int)
}

class HomeScreenViewModel: HomeScreenViewModelProtocol {
    var items: Observable<[AdCollectionViewCellConfig]> = Observable([])
    var error: Observable<String?> = Observable(nil)

    private let queue = DispatchQueue.global(qos: .background)
    private let service: HomeScreenServiceProtocol
    private let coordinator: AdsCoordinatorProtocol

    init(service: HomeScreenServiceProtocol, coordinator: AdsCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }

    func getData(completion: (() -> Void)?) {
        queue.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.service.getData { result in
                switch result {
                case .success(let newData):
                    self?.items.value = newData
                    DispatchQueue.main.async {
                        completion?()
                    }

                case .failure:
                    self?.error.value = "Ошибка при загрузке данных"
                }
            }
        }
    }

    func likeAd(id: Int) {
        if let index = items.value.firstIndex(where: { $0.id == id }) {
            items.value[index].isLiked = !items.value[index].isLiked
        }
        service.likeAd(id: id) { _ in }
    }

    func detailView(at index: Int) {
        coordinator.goToDetailView(id: items.value[index].id)
    }

    func searchAds(text: String) {
        let searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else { return }
        service.searchAd(startWith: searchText) { [weak self] result in
            switch result {
            case .success(let newData):
                self?.items.value = newData

            case .failure:
                self?.error.value = "Ошибка при загрузке данных"
            }
        }
    }
}
