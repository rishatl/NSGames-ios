//
//  ImageCollectionViewCell.swift
//  NSGames
//
//  Created by Rishat Latypov on 21.03.2022
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"

    // MARK: - UI
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        backgroundImageView.image = nil
    }

    func setImage(image: UIImage) {
        imageView.image = image
        backgroundImageView.image = image
    }

    // MARK: - Private Methods
    private func setConstraints() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurEffectView)

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
    }
}
