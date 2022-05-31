//
//  ProfileHeader.swift
//  NSGames
//
//  Created by Rishat Latypov on 08.04.2022
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {

    // MARK: - UI
    var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.meAnimoji.image
        imageView.tintColor = .grayView
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public UI Methods
    func setImage(image: UIImage) {
        userImageView.image = image
    }

    func setInfo(data: UserInfo) {
        usernameLabel.text = data.username
        emailLabel.text = data.email
    }

    // MARK: - Private Methods
    private func addSubviews() {
        addSubview(userImageView)
        addSubview(stackView)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(emailLabel)
    }

    private func setConstraints() {
        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(45)
        }

        userImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.equalTo(stackView.snp.top)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(userImageView.snp.width).dividedBy(0.9)
            make.centerX.equalToSuperview()
        }
    }
}
