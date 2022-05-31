//
//  DetailOfferViewConroller.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import UIKit
import SnapKit

class DetailOfferViewConroller: UIViewController {

    // MARK: - MVVM properties
    var viewModel: DetailViewModelProtocol?

    // MARK: - UI
    let tableView = UITableView()

    let noLabel: GrayLabel = {
        let label = GrayLabel()
        label.text = L10n.noShowOffers
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel?.title
        bindData()
        addSubviews()
        setConstraints()
        tableView.register(OfferDetailTableViewCell.self, forCellReuseIdentifier: OfferDetailTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        viewModel?.setup()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(noLabel)
    }

    private func bindData() {
        viewModel?.items.observe(on: self) { [weak self] value in
            guard let self = self else { return }
            if value.isEmpty {
                self.noLabel.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.noLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
        viewModel?.error.observe(on: self) { [weak self] value in
            if let self = self, let value = value {
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        noLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(10)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailOfferViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferDetailTableViewCell.identifier, for: indexPath) as? OfferDetailTableViewCell else { return UITableViewCell() }
        if let ad = viewModel?.items.value[indexPath.row] {
            cell.setData(configuration: ad)
            cell.delegate = self
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favAction = UIContextualAction(style: .normal, title: L10n.tabBarFavorite) { [weak self] ac, view, success in
            self?.viewModel?.saveFavorite(index: indexPath.row)
            success(true)
        }
        favAction.image = UIImage(named: "SaveIcon")
        favAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [favAction])
    }
}

// MARK: - OfferDetailTableViewCellDelegate
extension DetailOfferViewConroller: OfferDetailTableViewCellDelegate {
    func goToChat(id: Int) {
        viewModel?.goToChat(id: id)
    }

    func showTradeList(id: Int) {
        viewModel?.showTradeList(id: id)
    }
}
