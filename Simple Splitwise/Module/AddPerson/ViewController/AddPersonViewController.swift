//
//  AddPersonViewController.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/14/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

class AddPersonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var iconImages: [UIImageView]!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: AddPersonViewModel?
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        initViewModel()
        initRx()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Functions
    private func setupView() -> Void {        
        for iconImage in iconImages {
            iconImage.image = iconImage.image?.withRenderingMode(.alwaysTemplate)
            iconImage.tintColor = UIColor.darkBlue()
        }
        
        containView.layer.cornerRadius = 20
        containView.setShadow(cornerRadius: containView.layer.cornerRadius)
        
        acceptButton.layer.cornerRadius = acceptButton.frame.width / 2
        acceptButton.setShadow(cornerRadius: acceptButton.layer.cornerRadius)
        
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2
        cancelButton.setShadow(cornerRadius: cancelButton.layer.cornerRadius)
        
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = AddPersonViewModel()
        }
    }

    private func initRx() -> Void {
        actionRx()
        
        _ = Observable.combineLatest((self.viewModel?.name.asObservable())!, (self.viewModel?.email.asObservable())!, (self.viewModel?.phone.asObservable())!, (self.viewModel?.age.asObservable())!, resultSelector: { (name, email, phone, age) in
            return !name.isEmpty && !email.isEmpty && !phone.isEmpty && !age.isEmpty
        }).bind(to: acceptButton.rx.isEnabled)
    }
    
    private func actionRx() -> Void {
        nameTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.name.value = this.nameTextField.text ?? ""
        }).disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.email.value = this.emailTextField.text ?? ""
        }).disposed(by: disposeBag)
        
        phoneTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.phone.value = this.phoneTextField.text ?? ""
        }).disposed(by: disposeBag)
        
        ageTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.age.value = this.ageTextField.text ?? "0"
        }).disposed(by: disposeBag)
        
        acceptButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.addPerson()
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

    }
    
    private func addPerson() -> Void {
        guard let name = self.viewModel?.name.value else { return }
        guard let email = self.viewModel?.email.value else { return }
        guard let phone = self.viewModel?.phone.value else { return }
        guard let age = self.viewModel?.age.value else { return }
        if !email.isEmail {
            self.view.makeToast(APP_ERROR_MESSAGE.INVALID_EMAIL)
            return
        }
        if !phone.isPhone {
            self.view.makeToast(APP_ERROR_MESSAGE.INVALID_PHONE)
            return
        }
        let person = Person.initialize(name: name, email: email, phone: phone, age: Int(age) ?? 0)
        RealmManager.shared.add(object: person)
        self.dismiss(animated: true, completion: nil)
        
    }

}
