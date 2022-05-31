//
//  FavoriteOffersViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 24.05.2022
//

import UIKit
import SnapKit

class FavoriteOffersViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: FavoriteOffersViewModelProtocol?

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
        title = L10n.tabBarFavorite
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
extension FavoriteOffersViewController: UITableViewDelegate, UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viewModel?.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

// MARK: - OfferDetailTableViewCellDelegate
extension FavoriteOffersViewController: OfferDetailTableViewCellDelegate {
    func goToChat(id: Int) {
        viewModel?.goToChat(id: id)
    }

    func showTradeList(id: Int) {
        viewModel?.showTradeList(id: id)
    }
}
