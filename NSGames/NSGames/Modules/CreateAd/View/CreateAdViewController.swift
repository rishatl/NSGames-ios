//
//  CreateAdViewController.swift
//  NSGames
//
//  Created by Rishat Latypov on 13.04.2022
//

import UIKit
import SnapKit

class CreateAdViewController: UIViewController {

    // MARK: - MVVM properties
    var viewModel: CreateAdViewModelProtocol?

    // MARK: - UI
    let imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    let addImageButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitle(L10n.adPhoto, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .grayLight
        return button
    }()

    let staticDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.description
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let staticNameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.name
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let staticTradeList: UILabel = {
        let label = UILabel()
        label.text = L10n.tradeGames + ": "
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let staticPriceLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.price + ": "
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let gameInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let parameterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()

    let pageControl = UIPageControl()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = #colorLiteral(red: 0.9058029056, green: 0.9059333205, blue: 0.9057744741, alpha: 1).cgColor
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()

    let tradeListButton: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .grayLight
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .left
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.deletePhoto, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindData()
        addSubviews()
        setPageControl()
        setConstraints()
        setNavigationBar()
        setCollectionView()
        viewModel?.didLoad()
        setupTextViewAndFields()
        tradeListButton.setTitle(L10n.chooseGames, for: .normal)
        tradeListButton.addTarget(self, action: #selector(tradeListButtonAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Objc Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.snp.removeConstraints()
            scrollView.snp.makeConstraints { (make: ConstraintMaker) in
                make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalToSuperview().inset(keyboardSize.height)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.snp.removeConstraints()
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func doneButtonTapped() {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }

    @objc func doneBarButtonAction() {
        viewModel?.sendData(name: nameTextField.text, price: priceTextField.text, description: descriptionTextView.text)
    }

    @objc func tradeListButtonAction() {
        viewModel?.selectGames()
    }

    @objc private func addImageButtonAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionMakePhoto = UIAlertAction(title: L10n.makePhoto, style: .default) { [weak self] _ in
            self?.presentImagePickerController(type: .camera)
        }
        let actionOpenGallery = UIAlertAction(title: L10n.chooseFromGallery, style: .default) { [weak self] _ in
            self?.presentImagePickerController(type: .photoLibrary)
        }
        alert.addAction(actionMakePhoto)
        alert.addAction(actionOpenGallery)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func deleteButtonAction() {
        pageControl.numberOfPages -= 1
        viewModel?.deleteImage(index: pageControl.currentPage)
    }

    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageSlider)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(deleteButton)

        gameInfoStackView.addArrangedSubview(addImageButton)
        gameInfoStackView.addArrangedSubview(staticNameLabel)
        gameInfoStackView.addArrangedSubview(nameTextField)
        gameInfoStackView.addArrangedSubview(staticPriceLabel)
        gameInfoStackView.addArrangedSubview(priceTextField)
        gameInfoStackView.addArrangedSubview(staticTradeList)
        gameInfoStackView.addArrangedSubview(tradeListButton)
        gameInfoStackView.addArrangedSubview(staticDescriptionLabel)
        gameInfoStackView.addArrangedSubview(descriptionTextView)
        scrollView.addSubview(gameInfoStackView)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { (make: ConstraintMaker) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        imageSlider.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imageSlider.snp.width).multipliedBy(3.0 / 4.0)
            make.trailing.leading.equalToSuperview()
        }

        pageControl.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalTo(imageSlider)
            make.bottom.equalTo(imageSlider.snp.bottom).inset(4)
            make.height.equalTo(8)
        }

        deleteButton.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageSlider.snp.bottom).offset(6)
        }

        gameInfoStackView.snp.makeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(deleteButton.snp.bottom).offset(10)
            make.centerX.equalTo(imageSlider)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalTo(view.safeAreaInsets.bottom).inset(25)
        }

        descriptionTextView.snp.makeConstraints { (make: ConstraintMaker) in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }

    private func setCollectionView() {
        imageSlider.delegate = self
        imageSlider.dataSource = self
        imageSlider.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }

    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .grayLight
        pageControl.currentPageIndicatorTintColor = .buttonBlue
        pageControl.alpha = 0.6
    }

    private func setupTextViewAndFields() {
        nameTextField.delegate = self
        priceTextField.delegate = self

        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonTapped))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        nameTextField.inputAccessoryView = doneToolbar
        priceTextField.inputAccessoryView = doneToolbar
        descriptionTextView.inputAccessoryView = doneToolbar
    }

    private func setNavigationBar() {
        title = L10n.ad
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonAction))
    }

    private func bindData() {
        viewModel?.error.observe(on: self) { [weak self] value in
            if let self = self, let value = value {
                AlertPresenter.showAlert(controller: self, text: value)
            }
        }
        viewModel?.imageItems.observe(on: self) { [weak self] value in
            if value.isEmpty {
                self?.nameTextField.text = ""
                self?.priceTextField.text = ""
                self?.descriptionTextView.text = ""
                self?.viewModel?.didLoad()
            }
            self?.imageSlider.reloadData()
        }
        viewModel?.selectedGames.observe(on: self) { [weak self] value in
            if value.isEmpty {
                self?.tradeListButton.setTitle(L10n.chooseGames, for: .normal)
            } else {
                self?.tradeListButton.setTitle(L10n.choosenGames + " \(value.count)", for: .normal)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CreateAdViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.imageItems.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let imageFromViewModel = viewModel?.imageItems.value[indexPath.row] {
            cell.setImage(image: imageFromViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imageSlider.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageSlider {
            pageControl.currentPage = Int(scrollView.contentOffset.x / imageSlider.frame.size.width)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateAdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            priceTextField.becomeFirstResponder()

        case priceTextField:
            descriptionTextView.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateAdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addImage(to: editedImage.withRenderingMode(.alwaysOriginal))
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage(to: originalImage.withRenderingMode(.alwaysOriginal))
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func presentImagePickerController(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = type
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func addImage(to image: UIImage) {
        pageControl.numberOfPages += 1
        viewModel?.addImage(image: image)
    }
}
