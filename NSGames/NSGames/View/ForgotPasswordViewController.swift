//
//  ForgotPasswordViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 07.03.2022
//

import UIKit
import SnapKit

class ForgotPasswordViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: ForgotPasswordViewModelProtocol?

    // MARK: - UI
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = Asset.nsGamesIcon.image
        return iconImageView
    }()

    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.enterEmail
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    private let emailTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.email
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        return textField
    }()

    private let nextButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(L10n.next, for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.haveNoAccount
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.numberOfLines = 2
        label.textColor = .red
        return label
    }()

    private let scrollView = UIScrollView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        errorLabel.isHidden = true
        title = "Восстановление пароля"
        view.backgroundColor = .white
        emailTextField.delegate = self
        bindData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - obcj func
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + keyboardSize.height)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = scrollView.frame.size
    }

    @objc private func nextButtonAction() {
        viewModel?.checkEmail(email: emailTextField.text ?? "")
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(iconImageView)
        scrollView.addSubview(forgotPasswordLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(errorLabel)
        scrollView.addSubview(nextButton)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.width.height.equalTo(scrollView.snp.width).multipliedBy(0.3)
        }

        forgotPasswordLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
        }

        emailTextField.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(20)
        }

        errorLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }

        nextButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(errorLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    private func bindData() {
        viewModel?.emailError.bind { [weak self] text in
            guard let self = self else { return }
            self.errorLabel.text = text
            self.errorLabel.isHidden = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
