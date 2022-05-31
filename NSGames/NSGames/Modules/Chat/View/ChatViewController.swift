//
//  ChatViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 26.03.2022
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: ChatViewModel?

    // MARK: - UI
    let tableView: UITableView = {
        let table = UITableView()
        table.register(RightMessageTableViewCell.self, forCellReuseIdentifier: RightMessageTableViewCell.identifier)
        table.register(LeftMessageTableViewCell.self, forCellReuseIdentifier: LeftMessageTableViewCell.identifier)
        return table
    }()

    let inputTextView: TextViewWithPlaceholder = {
        let textView = TextViewWithPlaceholder()
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 4)
        textView.placeholder = "Введите текст сообщения"
        textView.isScrollEnabled = false
        textView.backgroundColor = .grayVeryLight
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return textView
    }()

    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow.up.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return button
    }()

    private let sendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 4
        return stackView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubviews()
        setConstraints()
        viewModel?.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc private func sendButtonAction() {
        if let text = inputTextView.text, !text.isEmpty {
            viewModel?.sendMessage(text: text)
            inputTextView.text = ""
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.height - view.safeAreaInsets.bottom
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }

    // MARK: - Private Methods
    private func bindData() {
        viewModel?.items.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel?.error.observe(on: self) { [weak self] value in
            if let self = self, let value = value {
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
        viewModel?.title.observe(on: self) { [weak self] value in
            self?.title = value
        }
    }

    private func addSubviews() {
        view.addSubview(tableView)
        sendStackView.addArrangedSubview(inputTextView)
        sendStackView.addArrangedSubview(sendButton)
        view.addSubview(sendStackView)
    }

    private func setConstraints() {
        sendStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }

        sendButton.imageView?.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
        }

        sendButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.16)
        }

        tableView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(sendStackView.snp.top).inset(4)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let config = viewModel?.items.value[indexPath.row] {
            if viewModel?.myId == config.senderId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RightMessageTableViewCell.identifier, for: indexPath) as? RightMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.style = .to
                cell.setData(configuration: config)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LeftMessageTableViewCell.identifier, for: indexPath) as? LeftMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.style = .from
                cell.setData(configuration: config)
                return cell
            }
        }
        return UITableViewCell()
    }
}
