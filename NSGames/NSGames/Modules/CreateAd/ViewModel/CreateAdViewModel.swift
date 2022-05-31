//
//  CreateAdViewModel.swift
//  NSGames
//
//  Created by Rishat Latypov on 13.04.2022
//

import UIKit

protocol CreateAdViewModelProtocol {
    var imageItems: Observable<[UIImage]> { get set }
    var error: Observable<String?> { get set }
    var selectedGames: Observable<[Int]> { get set }

    func didLoad()
    func addImage(image: UIImage)
    func deleteImage(index: Int)
    func sendData(name: String?, price: String?, description: String)
    func selectGames()
}

class CreateAdViewModel: CreateAdViewModelProtocol {

    // MARK: - Properties
    var imageItems: Observable<[UIImage]> = Observable([])
    var selectedGames: Observable<[Int]> = Observable([])
    var error: Observable<String?> = Observable(nil)

    private var hadNewImage = false
    private let service: CreateAdServiceProtocol
    private let coordinator: CreateAdCoordinatorProtocol

    init(service: CreateAdServiceProtocol, coordinator: CreateAdCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }

    func didLoad() {
        setNoImage()
    }

    func addImage(image: UIImage) {
        if !hadNewImage {
            imageItems.value.removeAll()
        }
        imageItems.value.append(image)
        hadNewImage = true
    }

    func setNoImage() {
        if imageItems.value.isEmpty, let image = UIImage(named: "NoImagePhoto") {
            imageItems.value = [image]
            hadNewImage = false
        }
    }

    func deleteImage(index: Int) {
        imageItems.value.remove(at: index)
        setNoImage()
    }

    func sendData(name: String?, price: String?, description: String) {
        guard let name = name else {
            return error.value = L10n.needName
        }
        if description.isEmpty {
            return error.value = L10n.needDescription
        }
        if price == nil && selectedGames.value.isEmpty {
            return error.value = L10n.needChooseGames
        }
        if !hadNewImage {
            return error.value = L10n.needPhoto
        }

        var data = [Data]()
        for image in imageItems.value {
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                data.append(jpegData)
            }
        }

        let ad = AdForm(title: name, price: Double(price ?? "") ?? 0, description: description, games: selectedGames.value)

        service.uploadAd(images: data, ad: ad) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.goToProfilePage()

            case .failure:
                self?.error.value = L10n.inetError
            }
        }

        imageItems.value = []
        selectedGames.value = []
    }

    func selectGames() {
        coordinator.goToSelectGamesView(games: selectedGames.value)
    }
}
