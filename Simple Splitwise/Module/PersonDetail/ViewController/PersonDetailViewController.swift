//
//  PersonDetailViewController.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class PersonDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var iconImages: [UIImageView]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: PersonDetailViewModel?
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        setupView()
        initRx()
    }
    
    // MARK: - Functions
    private func registerCells() -> Void {
        tableView.register(UINib(nibName: GenericTableViewCell001.cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: GenericTableViewCell001.cellIdentifier)
    }
    
    private func setupView() -> Void {
        for iconImage in iconImages {
            iconImage.image = iconImage.image?.withRenderingMode(.alwaysTemplate)
            iconImage.tintColor = UIColor.darkBlue()
        }
        
        if let name = self.viewModel?.name.value {
            nameTextField.text = name
        }
        
        if let phone = self.viewModel?.phone.value {
            phoneTextField.text = phone
        }
        
        if let email = self.viewModel?.email.value {
            emailTextField.text = email
        }
        
        if let age = self.viewModel?.age.value {
            ageTextField.text = age
        }
    }
    
    private func initRx() -> Void {
        actionRx()
        setupTableViewRx()
        _ = Observable.combineLatest((self.viewModel?.name.asObservable())!, (self.viewModel?.email.asObservable())!, (self.viewModel?.phone.asObservable())!, (self.viewModel?.age.asObservable())!, resultSelector: { (name, email, phone, age) in
            return !name.isEmpty && !email.isEmpty && !phone.isEmpty && !age.isEmpty
        }).bind(to: doneButton.rx.isEnabled)
    }
    
    func initViewModel(person: Person) -> Void {
        if viewModel == nil {
            viewModel = PersonDetailViewModel()
            self.viewModel?.person = person
            self.viewModel?.name.value = person.name ?? ""
            self.viewModel?.email.value = person.email ?? ""
            self.viewModel?.phone.value = person.phone ?? ""
            self.viewModel?.age.value = "\(person.age)"
            self.viewModel?.generateListRelative()
            self.viewModel?.generateListData()
        }
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
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.handleDoneAction()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupTableViewRx() -> Void {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Object>>(
            configureCell: { [weak self] (ds, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: GenericTableViewCell001.cellIdentifier, for: indexPath) as! GenericTableViewCell001
                if let relative = element as? Relative, let model = self?.viewModel?.generateRelativeCell(relative: relative) {
                    cell.initData(model: model)
                }
                return cell
            },titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
        })
        viewModel?.listData?.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, dataSource[indexPath])
            }.subscribe(onNext: { [weak self] indexPath, object in
                guard let this = self else { return }
                this.tableView.deselectRow(at: indexPath, animated: false)
            }).disposed(by: disposeBag)
    }
    
    private func handleDoneAction() -> Void {
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
        
        if let p = self.viewModel?.person {
            let person = Person.initialize(name: name, email: email, phone: phone, age: Int(age) ?? 0)
            person.id = p.id
            if let relatives = p.relatives {
                for relative in relatives {
                    person.relatives?.append(relative)
                }
            }
            RealmManager.shared.update(person: person)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

// MARK: - UITableViewDelegate
extension PersonDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
