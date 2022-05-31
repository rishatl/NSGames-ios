//
//  ConversationListViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.03.2022
//

import UIKit
import SnapKit
import CoreData

class ConversationListViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: ConversationListViewModelProtocol?

    // MARK: - UI
    let tableView: UITableView = {
        let table = UITableView()
        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Чат"
        tableView.delegate = self
        tableView.dataSource = self
        bindData()
        viewModel?.setup()
        addSubviews()
        setConstraints()
    }

    // MARK: - Private Methods
    private func bindData() {
        viewModel?.items.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel?.error.observe(on: self) {[weak self] value in
            if let self = self, let value = value {
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        if let config = viewModel?.items.value[indexPath.row] {
            cell.configure(with: config)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectItem(at: indexPath.row)
    }
}
