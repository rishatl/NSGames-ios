//
//  LoginViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 03.03.2022
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: SignInViewModelProtocol?

    // MARK: - UI
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = Asset.nsGamesIcon.image
        return iconImageView
    }()

    let signInLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.signIn
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    let emailTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.email
        return textField
    }()

    let passwordTextField: DataTextField = {
        let textField = DataTextField()
        textField.placeholder = L10n.password
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()

    let forgotPasswordButton: BlueTextButton = {
        let button = BlueTextButton()
        button.setTitle(L10n.forgotPassword, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        return button
    }()

    let haveNoAccount: GrayLabel = {
        let label = GrayLabel()
        label.text = L10n.haveNoAccount
        label.font = UIFont.systemFont(ofSize: 15)
        label.tintColor = .grayLabel
        return label
    }()

    let signUpButton: BlueTextButton = {
        let button = BlueTextButton()
        button.setTitle(L10n.createAccount, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return button
    }()

    let signInButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(L10n.signIn, for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
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

    let loadingView = LoadingView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        bindData()
        title = L10n.auth
        loadingView.isHidden = true
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc private func signUpButtonAction() {
        viewModel?.registration()
    }

    @objc private func signInButtonAction() {
        viewModel?.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        self.loadingView.isHidden = false
    }

    @objc private func forgotPasswordButtonAction() {
        viewModel?.forgotPassword()
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
        scrollView.addSubview(signInLabel)
        userDataStackView.addArrangedSubview(emailTextField)
        userDataStackView.addArrangedSubview(passwordTextField)
        scrollView.addSubview(userDataStackView)
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(signInButton)
        stackView.addArrangedSubview(haveNoAccount)
        stackView.addArrangedSubview(signUpButton)
        scrollView.addSubview(stackView)
        view.addSubview(loadingView)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        iconImageView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(scrollView.snp.width).multipliedBy(0.3)
        }

        signInLabel.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
        }

        userDataStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(signInLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        forgotPasswordButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.trailing.equalTo(userDataStackView.snp.trailing)
            make.top.equalTo(userDataStackView.snp.bottom).offset(10)
        }

        signInButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(signInButton.snp.bottom).offset(10)
        }

        loadingView.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalTo(loadingView.snp.height)
        }
    }

    private func bindData() {
        viewModel?.signInError.bind { [weak self] text in
            guard let self = self else { return }
            self.errorLabel.text = text
            self.userDataStackView.addArrangedSubview(self.errorLabel)
            self.loadingView.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
