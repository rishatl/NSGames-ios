//
//  HomeScreenViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 13.03.2022
//

import UIKit
import SnapKit

enum HomeScreenViewControllerStyle {
    case favorites
    case home
}

class HomeScreenViewController: UIViewController {

    // MARK: - MVVM properties
    var style: HomeScreenViewControllerStyle = .home
    var viewModel: HomeScreenViewModelProtocol?

    // MARK: - UI
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = HomeScreenCellCollectionConstants.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    let noAdsLabel: GrayLabel = {
        let label = GrayLabel()
        label.text = "Нет объявлений для показа."
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    let searchController = UISearchController(searchResultsController: nil)

    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(updateData), for: .valueChanged)
        return control
    }()

    // MARK: - Properties
    var selectedView: HomeScreenCollectionViewCell?
    private var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCollectionView()
        setNavigationBarStyle()
        addSubviews()
        constraints()
        bindData()
        getData()
    }

    // MARK: - Objc Methods
    @objc func updateData() {
        viewModel?.getData(completion: nil)
    }

    // MARK: - Private Methods
    private func setNavigationBarStyle() {
        if style == .favorites {
            title = "Избранное"
        } else {
            title = "Главная"

            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск"
            searchController.searchBar.delegate = self
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true

            navigationController?.navigationBar.barTintColor = UIColor.grayLight
        }
    }

    private func setCollectionView() {
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeScreenCollectionViewCell.self, forCellWithReuseIdentifier: HomeScreenCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 14, left: HomeScreenCellCollectionConstants.leftDistance, bottom: 14, right: HomeScreenCellCollectionConstants.rightDistance)
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(indicator)
        view.addSubview(noAdsLabel)
    }

    private func constraints() {
        collectionView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        indicator.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(view.snp.width).multipliedBy(0.5)
        }

        noAdsLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(10)
        }
    }

    private func getData() {
        collectionView.isHidden = true
        indicator.isHidden = false
        noAdsLabel.isHidden = true
        viewModel?.getData { [weak self] in
            if let collectionView = self?.collectionView {
                self?.indicator.isHidden = true
                UIView.transition(with: collectionView, duration: 0.6,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    collectionView.isHidden = false
                                  })
            }
        }
    }

    private func bindData() {
        viewModel?.items.observe(on: self) { [weak self] value in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()

            if value.isEmpty {
                self.collectionView.isHidden = true
                UIView.transition(with: self.view,
                                  duration: 1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.noAdsLabel.isHidden = false
                                  })
            } else {
                self.noAdsLabel.isHidden = true
                self.collectionView.reloadData()
                self.indicator.isHidden = true
                UIView.transition(with: self.collectionView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    self?.collectionView.isHidden = false
                                  })
            }
        }
        viewModel?.error.observe(on: self) { [weak self] value in
            if let self = self, let value = value {
                self.refreshControl.endRefreshing()
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.items.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.identifier, for: indexPath) as? HomeScreenCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        if let data = viewModel?.items.value[indexPath.row] {
            cell.setData(configuration: data)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        if view.frame.height * 0.26 < 190 {
            height = 190
        } else {
            height = view.frame.height * 0.26
        }
        return CGSize(width: HomeScreenCellCollectionConstants.itemWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedView = collectionView.cellForItem(at: indexPath) as? HomeScreenCollectionViewCell
        viewModel?.detailView(at: indexPath.row)
    }
}

// MARK: - HomeScreenCellDelegate
extension HomeScreenViewController: HomeScreenCellDelegate {
    func likeAd(config: AdCollectionViewCellConfig) {
        viewModel?.likeAd(id: config.id)
    }
}

// MARK: - UISearchControllerDelegate
extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { [weak self] value in
            self?.collectionView.isHidden = true
            self?.indicator.isHidden = false
            self?.indicator.startAnimating()
            self?.viewModel?.searchAds(text: searchText)
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getData()
    }
}
