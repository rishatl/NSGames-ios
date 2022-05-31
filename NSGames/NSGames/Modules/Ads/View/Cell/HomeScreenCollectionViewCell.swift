//
//  HomeScreenCollectionViewCell.swift
//  NSGames
//
//  Created by Rishat Latypov on 14.03.2022
//

import UIKit
import SnapKit
import Kingfisher

protocol HomeScreenCellDelegate: AnyObject {
    func likeAd(config: AdCollectionViewCellConfig)
}

class HomeScreenCollectionViewCell: UICollectionViewCell {

    static let identifier = "HomeScreenCollectionViewCell"
    var configuration: AdCollectionViewCellConfig?
    weak var delegate: HomeScreenCellDelegate?

    // MARK: - UI
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.grayLabel
        label.numberOfLines = 2
        return label
    }()

    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.heart.image, for: .normal)
        return button
    }()

    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Properties
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        contentView.layer.cornerRadius = 14
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        layer.shadowPath = UIBezierPath(rect: bounds.offsetBy(dx: 0, dy: 10)).cgPath
        self.clipsToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        likeButton.setImage(Asset.heart.image, for: .normal)
    }

    // MARK: - Public UI Methods
    func setData(configuration: AdCollectionViewCellConfig) {
        self.configuration = configuration
        if let url = URL(string: BaseUrl.kingFisherHostImageUrl + configuration.image) {
            imageView.kf.setImage(with: url)
        }
        nameLabel.text = configuration.name
        if configuration.isLiked {
            likeButton.setImage(Asset.selectedHeart.image, for: .normal)
        }
        timeLabel.text = dateToString(date: configuration.date)
    }

    // MARK: - Objc Methods
    @objc func likeButtonAction(loaded: Bool = true) {
        guard var configuration = configuration else {
            return
        }
        if configuration.isLiked {
            likeButton.setImage(Asset.heart.image, for: .normal)
            configuration.isLiked = false
        } else {
            configuration.isLiked = true
        }
        self.configuration = configuration
        delegate?.likeAd(config: configuration)
    }

    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(likeButton)
        infoStackView.addArrangedSubview(stackView)
        infoStackView.addArrangedSubview(timeLabel)
    }

    private func setConstraints() {
        imageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.height.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().inset(6)
        }

        infoStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(6)
        }

        likeButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.height.equalTo(infoStackView.snp.width).multipliedBy(0.15)
            make.width.equalTo(infoStackView.snp.width).multipliedBy(0.15 * 48 / 45)
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
