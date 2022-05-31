//
//  HomeScreenViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 17.03.2022
//

import UIKit
import Kingfisher

protocol GameViewModelProtocol {
    var imageItems: Observable<[UIImage]> { get set }
    var gameSreenConfig: Observable<GameSreenConfig?> { get set }
    var error: Observable<String?> { get set }

    func close()
    func getData()
    func goToChat()
    func makeOffer()
}

class MockGameViewModel: GameViewModelProtocol {

    // MARK: - Properties
    var imageItems: Observable<[UIImage]> = Observable([])
    var error: Observable<String?> = Observable(nil)
    var gameSreenConfig: Observable<GameSreenConfig?> = Observable(nil)

    private let id: Int
    private let service: GameServiceProtocol
    private let coordinator: AdsCoordinatorProtocol

    init(service: GameServiceProtocol, coordinator: AdsCoordinatorProtocol, id: Int) {
        self.service = service
        self.coordinator = coordinator
        self.id = id
    }

    func getData() {
        service.getStringData(id: id) { [weak self] result in
            switch result {
            case .success(let config):
                self?.gameSreenConfig.value = config
                for image in config.photoNames {
                    if let url = URL(string: BaseUrl.kingFisherHostImageUrl + image) {
                        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
                            switch result {
                            case .success(let downloadedImage):
                                DispatchQueue.main.async {
                                    self?.imageItems.value.append(downloadedImage.image)
                                }

                            default:
                                break
                            }
                        })
                    }
                }

            case .failure:
                self?.error.value = InetErrorNames.failedConnection
            }
        }
    }

    func close() {
        coordinator.close()
    }

    func makeOffer() {
        coordinator.goToOfferView(id: id)
    }

    func goToChat() {
        if let data = gameSreenConfig.value {
            coordinator.goToChat(messageId: data.messageId, username: data.username)
        }
    }
}
