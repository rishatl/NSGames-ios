//
//  AdTableViewCell.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import UIKit
import SnapKit

protocol AdTableDelegate: AnyObject {
    func updateTable()
}

class AdTableViewCell: UITableViewCell {

    static let identifier = "AdTableViewCell"

    // MARK: - UI
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = .white
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let numberOfOffersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    let staticNumberOfOffersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = L10n.numberOfOffers
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    let numberOfViewsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    let staticNumberOfViewsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = L10n.numberOfViews
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let offerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.contentMode = .scaleToFill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    let viewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.contentMode = .scaleToFill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Properties
    weak var delegate: AdTableDelegate?

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none

        addSubviews()
        setConstraints()

        backView.layer.shadowRadius = 6
        backView.layer.shadowOpacity = 0.15
        backView.layer.shadowPath = UIBezierPath(rect: bounds.offsetBy(dx: 0, dy: 6)).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public UI Methods
    func setData(configuration: AdTableViewCellConfig) {
        nameLabel.text = configuration.name
        numberOfOffersLabel.text = "\(configuration.numberOfOffers)"
        numberOfViewsLabel.text = "\(configuration.views)"
        adImageView.image = UIImage(data: configuration.photo)
    }

    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(backView)
        backView.addSubview(stackView)
        offerStackView.addArrangedSubview(staticNumberOfOffersLabel)
        offerStackView.addArrangedSubview(numberOfOffersLabel)
        viewsStackView.addArrangedSubview(staticNumberOfViewsLabel)
        viewsStackView.addArrangedSubview(numberOfViewsLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(adImageView)
        stackView.addArrangedSubview(offerStackView)
        stackView.addArrangedSubview(viewsStackView)
    }

    private func setConstraints() {
        if !backView.constraints.isEmpty {
            stackView.snp.removeConstraints()
            backView.snp.removeConstraints()
            adImageView.snp.removeConstraints()
        } else {
            staticNumberOfViewsLabel.snp.contentCompressionResistanceHorizontalPriority = 1000
            staticNumberOfOffersLabel.snp.contentCompressionResistanceHorizontalPriority = 1000
            nameLabel.snp.contentCompressionResistanceVerticalPriority = 1000
        }

        backView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().inset(10)
        }

        adImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.4)
            make.height.lessThanOrEqualTo(adImageView.snp.width)
        }

        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.left.equalToSuperview().offset(12)
            make.bottom.right.equalToSuperview().inset(12)
        }
    }
}
