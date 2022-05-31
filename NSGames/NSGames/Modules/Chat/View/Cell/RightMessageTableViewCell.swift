//
//  MessageTableViewCell.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import UIKit
import SnapKit

enum MessageTableViewCellType {
    case to
    case from
}

class RightMessageTableViewCell: UITableViewCell {

    static let identifier = "RightMessageTableViewCell"

    // MARK: - UI
    let messageView = ShadowView()

    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .right
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Properties
    var style: MessageTableViewCellType?

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }

    // MARK: - Public UI Methods
    func setData(configuration: Message) {
        dateLabel.text = prepareDate(date: configuration.created)
        messageTextLabel.text = configuration.content
        if let style = style {
            switch style {
            case .to:
                messageView.backgroundColor = .buttonBlue
                messageTextLabel.textColor = .white
                dateLabel.textColor = .white

            case .from:
                messageView.backgroundColor = .grayLabel
                messageTextLabel.textColor = .black
                dateLabel.textColor = .black
            }
        }
    }

    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(messageView)
        stackView.addArrangedSubview(messageTextLabel)
        stackView.addArrangedSubview(dateLabel)
        contentView.addSubview(stackView)
    }

    private func makeConstraints() {
        messageTextLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: .vertical)
        dateLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        messageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            make.bottom.equalToSuperview().inset(4)
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(8)
        }

        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(messageView).offset(8)
            make.bottom.equalTo(messageView).inset(8)
            make.leading.equalTo(messageView).offset(8)
            make.trailing.equalTo(messageView).inset(8)
        }
    }

    // MARK: - Helpers
    private func prepareDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm dd MMM")
        }
        return dateFormatter.string(from: date)
    }
}
