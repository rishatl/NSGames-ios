//
//  ProfileViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: ProfileViewModelProtocol?

    // MARK: - UI
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let header = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5))
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(updateData), for: .valueChanged)
        return control
    }()

    // MARK: - Properties
    private var isAnimated = false
    private var indexPathOfAnimated: IndexPath?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.profile
        bindData()
        addSubviews()
        setConstraints()
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header
        tableView.refreshControl = refreshControl
        tableView.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.setup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.logout, style: .done, target: self, action: #selector(exitButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: L10n.tabBarFavorite, style: .done, target: self, action: #selector(favorites))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isAnimated, let indexPath = indexPathOfAnimated {
            guard let cell = tableView.cellForRow(at: indexPath) as? AdTableViewCell else { return }

            cell.backView.snp.updateConstraints { (make: ConstraintMaker) in
                make.top.left.equalToSuperview().offset(10)
                make.bottom.right.equalToSuperview().inset(10)
            }
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 15,
                           options: .curveEaseInOut,
                           animations: { [weak cell] in
                            cell?.backView.layer.cornerRadius = 14
                            cell?.layoutIfNeeded()
                           })
        }
    }

    // MARK: - Objc Methods
    @objc func exitButtonAction() {
        viewModel?.quit()
    }

    @objc func updateData() {
        viewModel?.setup()
    }

    @objc func favorites() {
        viewModel?.favorites()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func bindData() {
        viewModel?.items.observe(on: self) { [weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        viewModel?.userInfo.observe(on: self) { [weak self] value in
            if let data = value {
                self?.header.setInfo(data: data)
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
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        L10n.ads
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.identifier, for: indexPath) as? AdTableViewCell else { return UITableViewCell() }
        if let ad = viewModel?.items.value[indexPath.row] {
            cell.setData(configuration: ad)
        }
        cell.backgroundColor = tableView.backgroundColor
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viewModel?.deleteAd(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) as? AdTableViewCell else { return }
        cell.backView.snp.removeConstraints()
        cell.backView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 10,
                       options: [.curveEaseInOut],
                       animations: { [unowned cell] in
                        cell.layoutIfNeeded()
                        cell.backView.layer.cornerRadius = 0
                       },
                       completion: { [weak self] _ in
                        self?.isAnimated = true
                        self?.indexPathOfAnimated = indexPath
                        self?.viewModel?.didSelectItem(at: indexPath.row)
                       })
        }
}
