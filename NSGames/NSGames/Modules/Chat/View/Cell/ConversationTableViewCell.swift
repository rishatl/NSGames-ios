//
//  ConverstaionCell.swift
//  NSGames
//
//  Created by Rishat Latypov on 25.03.2022
//

import UIKit
import SnapKit

class ConversationTableViewCell: UITableViewCell {

    static let identifier = "ConversationViewCell"

    // MARK: - UI
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        return label
    }()

    let lastMessageLabel: GrayLabel = {
        let label = GrayLabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    let dateLastMessageLabel: GrayLabel = {
        let label = GrayLabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        lastMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public UI Methods
    public func configure(with model: Conversation) {
        lastMessageLabel.text = model.lastMessageText ?? "Нет сообщений"
        userNameLabel.text = model.username

        dateLastMessageLabel.text = prepareDate(date: model.lastActivity) ?? "-"

        lastMessageLabel.font = .systemFont(ofSize: 19, weight: .regular)
    }

    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(dateLastMessageLabel)
    }

    private func makeConstraints() {
        userNameLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(dateLastMessageLabel)
            make.leading.equalToSuperview().offset(10)
        }

        dateLastMessageLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(userNameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }

        userNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        lastMessageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)

        lastMessageLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    // MARK: - Helpers
    private func prepareDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd")
        }
        return dateFormatter.string(from: date)
    }
}
