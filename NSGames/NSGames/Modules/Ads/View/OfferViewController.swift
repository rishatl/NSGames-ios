//
//  OfferViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 21.03.2022
//

import UIKit
import SnapKit

class OfferViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: OfferViewModelProtocol?

    // MARK: - UI
    let offerTypeContol: UISegmentedControl = {
        let items = [L10n.buy, L10n.trade]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(changeType), for: .valueChanged)
        return control
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.placeholder = L10n.preferPrice
        return textField
    }()

    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = L10n.commentToOffer
        return textField
    }()

    let submitButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(L10n.submit, for: .normal)
        button.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        return button
    }()

    let gamesButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.choose, for: .normal)
        button.setTitleColor(.buttonBlue, for: .normal)
        button.setTitleColor(.grayLight, for: .highlighted)
        button.addTarget(self, action: #selector(gamesButtonAction), for: .touchUpInside)
        return button
    }()

    let gamesLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.tradeGames
        return label
    }()

    let gamesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Properties
    lazy var gamesId = [Int]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Предложение"
        view.backgroundColor = .white
        setUI()
        addSubviews()
        setConstraints()
        bindData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc private func changeType() {
        switch offerTypeContol.selectedSegmentIndex {
        case 0:
            gamesStackView.removeFromSuperview()
            stackView.addArrangedSubview(priceTextField)

        case 1:
            priceTextField.removeFromSuperview()
            stackView.addArrangedSubview(gamesStackView)

        default:
            break
        }
    }

    @objc private func gamesButtonAction() {
        viewModel?.selectGames()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y == 0 {
            let differenceHeight = view.frame.height - keyboardSize.height
            if submitButton.frame.maxY > differenceHeight {
                view.frame.origin.y -= submitButton.frame.maxY - differenceHeight + UIScreen.main.bounds.height / 15
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func submitButtonAction() {
        guard let description = descriptionTextField.text, !description.isEmpty else {
            AlertPresenter.showAlert(controller: self, text: "Добавьте описание")
            return
        }

        switch offerTypeContol.selectedSegmentIndex {
        case 0:
            if let priceText = priceTextField.text, !priceText.isEmpty, let price = Double(priceText) {
                viewModel?.sendOffer(description: description, price: price)
            } else {
                AlertPresenter.showAlert(controller: self, text: "Добавьте цену")
            }

        case 1:
            if let value = viewModel?.selectedGames.value, value.isEmpty {
                AlertPresenter.showAlert(controller: self, text: "Нужно выбрать хотя бы одну игру")
            }
            viewModel?.sendOffer(description: description, price: nil)

        default:
            break
        }
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(offerTypeContol)
        view.addSubview(stackView)
        stackView.addArrangedSubview(descriptionTextField)
        stackView.addArrangedSubview(priceTextField)
        view.addSubview(submitButton)
        gamesStackView.addArrangedSubview(gamesLabel)
        gamesStackView.addArrangedSubview(gamesButton)
    }

    private func setConstraints() {
        offerTypeContol.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        stackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(offerTypeContol.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        submitButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalToSuperview().multipliedBy(0.65)
        }

        gamesButton.snp.contentHuggingHorizontalPriority = 251
    }

    private func setUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        priceTextField.delegate = self
        descriptionTextField.delegate = self
    }

    private func bindData() {
        viewModel?.selectedGames.observe(on: self) { [weak self] value in
            self?.gamesButton.setTitle("Выбрано игр - \(value.count)", for: .normal)
        }
    }
}

// MARK: - UITextFieldDelegate
extension OfferViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case priceTextField:
            descriptionTextField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
