//
//  SignUpViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 05.03.2022
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {

    // MARK: - MVVM propertiesb
    var viewModel: SignUpViewModelProtocol?

    // MARK: - UI
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = Asset.nsGamesIcon.image
        return iconImageView
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.creatingAccount
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    let loginTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.login
        return textField
    }()

    let emailTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.email
        textField.keyboardType = .emailAddress
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

    let haveAccount: GrayLabel = {
        let label = GrayLabel()
        label.text = L10n.haveAccount
        label.font = UIFont.systemFont(ofSize: 15)
        label.tintColor = .grayLabel
        return label
    }()

    var signInButton: BlueTextButton = {
        let button = BlueTextButton()
        button.setTitle(L10n.logIn, for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()

    let signUpButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Создать аккаунт", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return button
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
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
        title = L10n.creatingAccount
        view.backgroundColor = .white
        loginTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc private func signInButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func signUpButtonAction() {
        viewModel?.signUp(login: loginTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", passwordAgain: passwordAgainTextField.text ?? "")
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
        scrollView.addSubview(iconImageView)
        scrollView.addSubview(signUpLabel)
        userDataStackView.addArrangedSubview(loginTextField)
        userDataStackView.addArrangedSubview(emailTextField)
        userDataStackView.addArrangedSubview(passwordTextField)
        userDataStackView.addArrangedSubview(passwordAgainTextField)
        stackView.addArrangedSubview(haveAccount)
        stackView.addArrangedSubview(signInButton)
        scrollView.addSubview(userDataStackView)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(stackView)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view)
        }

        iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(scrollView.snp.width).multipliedBy(0.3)
        }

        signUpLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
        }

        userDataStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        signUpButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(userDataStackView.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }

    private func bindData() {
        viewModel?.signUpError.bind { [weak self] text in
            guard let self = self else { return }
            self.errorLabel.text = text
            self.userDataStackView.addArrangedSubview(self.errorLabel)
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            emailTextField.becomeFirstResponder()

        case emailTextField:
            passwordTextField.becomeFirstResponder()

        case passwordTextField:
            passwordAgainTextField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
