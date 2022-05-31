//
//  SelectGamesViewContoller.swift
//  NSGames
//
//  Created by Rishat Latypov on 22.03.2022
//

import UIKit
import SnapKit

class SelectGamesViewContoller: UIViewController {

    // MARK: - MVVM properties
    var viewModel: SelectGamesViewModel?

    // MARK: - UI
    let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Propertie
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.chooseGamesTitle
        setNavigationBarStyle()
        bindData()
        addSubviews()
        setConstraints()
        tableView.register(SelectGameTableViewCell.self, forCellReuseIdentifier: SelectGameTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.getData()
    }

    // MARK: - Objc Methods
    @objc func doneButtonAction() {
        viewModel?.done()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func bindData() {
        viewModel?.games.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
            self?.animateTable()
        }
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setNavigationBarStyle() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
    }

    private func animateTable() {
        for cell in tableView.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.frame.height)
        }

        var delay = 0
        for cell in tableView.visibleCells {
            cell.alpha = 0.3
            UIView.animate(withDuration: 1 - 0.02 * Double(delay),
                           delay: 0.05 * Double(delay),
                           options: [.curveEaseInOut],
                           animations: {
                            cell.transform = .identity
                            cell.alpha = 1.0
                           },
                           completion: nil)
            delay += 1
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectGamesViewContoller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.isFiltering = isFiltering
        return viewModel?.games.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectGameTableViewCell.identifier, for: indexPath)
        viewModel?.isFiltering = isFiltering
        if let game = viewModel?.games.value[indexPath.row] {
            if let viewModel = viewModel, viewModel.setCheckMark(index: indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.textLabel?.text = game.name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.isFiltering = isFiltering
        viewModel?.selectGame(index: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? SelectGameTableViewCell {
            cell.isCheckMark = !cell.isCheckMark
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SelectGamesViewContoller: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        if !searchText.isEmpty {
            viewModel?.filter(searchText)
        }
    }
}
