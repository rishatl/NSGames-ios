//
//  GamePageViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 21.03.2022
//

import UIKit
import SnapKit

class GameViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: GameViewModelProtocol?

    // MARK: - UI
    let imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 3
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 3
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    var sended = false {
        didSet {
            UIView.animate(withDuration: 1,
                           animations: { [weak self] in
                            self?.readyButton.backgroundColor = UIColor.greenButton
                            self?.readyButton.setTitle("Предложение отправлено!", for: .normal)
                           })
        }
    }

    let readyButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Готов купить!", for: .normal)
        button.addTarget(self, action: #selector(readyButtonAction), for: .touchUpInside)
        return button
    }()

    let chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .greenButton
        button.layer.cornerRadius = 14
        button.setTitle("Написать", for: .normal)
        button.addTarget(self, action: #selector(goToChat), for: .touchUpInside)
        return button
    }()

    let staticDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание: "
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let gameInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let parameterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let staticStateLabel: GrayLabel = {
        let label = GrayLabel()
        label.text = "Состояние"
        return label
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()

    let pageControl = UIPageControl()
    let dateLabel = GrayLabel()

    // MARK: - Properties
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh MMM"
        return formatter
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Объявление"
        if ProcessInfo.processInfo.environment["animation"] == "true" {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(closeButtonAction))
        }
        bindData()
        setCollectionView()
        setPageControl()
        viewModel?.getData()
        addSubviews()
        setConstraints()
    }

    // MARK: - Objc Methods
    @objc private func readyButtonAction() {
        viewModel?.makeOffer()
    }

    @objc private func goToChat() {
        viewModel?.goToChat()
    }

    @objc private func closeButtonAction() {
        viewModel?.close()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageSlider)
        scrollView.addSubview(pageControl)
        gameInfoStackView.addArrangedSubview(gameNameLabel)
        gameInfoStackView.addArrangedSubview(priceLabel)
        gameInfoStackView.addArrangedSubview(readyButton)
        gameInfoStackView.addArrangedSubview(chatButton)
        gameInfoStackView.addArrangedSubview(staticDescriptionLabel)
        gameInfoStackView.addArrangedSubview(descriptionLabel)
        scrollView.addSubview(gameInfoStackView)
        scrollView.addSubview(dateLabel)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        imageSlider.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.trailing.leading.equalToSuperview()
        }

        pageControl.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(imageSlider)
            make.bottom.equalTo(imageSlider.snp.bottom).inset(4)
            make.height.equalTo(8)
        }

        readyButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.height.equalTo(45)
        }

        chatButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.height.equalTo(45)
        }

        gameInfoStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(imageSlider.snp.bottom).offset(10)
            make.centerX.equalTo(imageSlider)
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        dateLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(gameInfoStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }

    private func setCollectionView() {
        imageSlider.delegate = self
        imageSlider.dataSource = self
        imageSlider.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }

    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .grayLight
        pageControl.currentPageIndicatorTintColor = .buttonBlue
        pageControl.alpha = 0.6
    }

    private func bindData() {
        viewModel?.imageItems.observe(on: self) { [weak self] values in
            self?.pageControl.numberOfPages = values.count
            self?.imageSlider.reloadData()
        }
        viewModel?.gameSreenConfig.observe(on: self) { [weak self] game in
            if let game = game {
                self?.priceLabel.text = "\(game.price) ₽"
                self?.dateLabel.text = self?.dateToString(date: game.date)
                self?.descriptionLabel.text = game.description
                self?.gameNameLabel.text = game.title
            }
        }
        viewModel?.error.observe(on: self) { [weak self] value in
            if let self = self, let value = value {
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
    }

    private func dateToString(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "Сегодня в HH:mm"
            return dateFormatter.string(from: date)
        }
        if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "Вчера в HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMMM в HH:mm"
        }
        return dateFormatter.string(from: date)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.imageItems.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let imageFromViewModel = viewModel?.imageItems.value[indexPath.row] {
            cell.setImage(image: imageFromViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imageSlider.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageSlider {
            pageControl.currentPage = Int(scrollView.contentOffset.x / imageSlider.frame.size.width)
        }
    }
}
