//
//  SignUpViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.03.2022
//

import UIKit
import SnapKit

class CodeVerifyViewController: UIViewController {

    // MARK: - MVVM propertiesb
    var viewModel: CodeVerifyViewModelProtocol?

    // MARK: - UI
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.newPassword
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    let codeTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.newPassword
        return textField
    }()

    let passwordTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.password
        textField.isSecureTextEntry = true
        return textField
    }()

    let passwordAgainTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.passwordAgain
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()

    let signInButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(L10n.signIn, for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()

    let userDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.haveNoAccount
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.numberOfLines = 2
        label.textColor = .red
        return label
    }()

    let scrollView = UIScrollView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        addSubviews()
        setConstraints()
        title = L10n.password
        view.backgroundColor = .white
        codeTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc private func signInButtonAction() {
        if  let password = passwordTextField.text, !password.isEmpty, passwordTextField.text == passwordAgainTextField.text {
            viewModel?.checkCode(code: codeTextField.text ?? "", password: password)
        } else {
            self.errorLabel.text = L10n.passwordDif
            self.userDataStackView.addArrangedSubview(self.errorLabel)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + keyboardSize.height)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = scrollView.frame.size
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(topLabel)
        userDataStackView.addArrangedSubview(codeTextField)
        userDataStackView.addArrangedSubview(passwordTextField)
        userDataStackView.addArrangedSubview(passwordAgainTextField)
        scrollView.addSubview(userDataStackView)
        scrollView.addSubview(signInButton)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        topLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }

        userDataStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        signInButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(userDataStackView.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    private func bindData() {
        viewModel?.codeVerifyError.bind { [weak self] text in
            guard let self = self else { return }
            self.errorLabel.text = text
            self.userDataStackView.addArrangedSubview(self.errorLabel)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CodeVerifyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {

        case codeTextField:
            passwordTextField.becomeFirstResponder()

        case passwordTextField:
            passwordAgainTextField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
