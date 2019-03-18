//
//  BillDetailViewController.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/17/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import RxCocoa
import RxSwift
import Toast_Swift
import RealmSwift

class BillDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var paidByButton: UIButton!
    @IBOutlet weak var splitMethodButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paidForButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet var iconImages: [UIImageView]!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: BillDetailViewModel?
    var presentSelectPersonViewSegue = "presentSelectPersonView"
    var isUpdate: Bool = false
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        registerCells()
        initViewModel()
        initRx()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.generateListData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    private func registerCells() -> Void {
        tableView.register(UINib(nibName: GenericTableViewCell002.cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: GenericTableViewCell002.cellIdentifier)
    }

    private func setupView() -> Void {
        if self.isUpdate {
            self.navigationTitleLabel.text = "Bill Detail"
        } else {
            self.navigationTitleLabel.text = "Add Bill"
        }
        
        for iconImage in iconImages {
            iconImage.image = iconImage.image?.withRenderingMode(.alwaysTemplate)
            iconImage.tintColor = UIColor.darkBlue()
        }
        
        if let title = self.viewModel?.title {
            self.titleTextField.text = title
        }
        
        if let description = self.viewModel?.description {
            self.descriptionTextView.text = description
        }
        
        let total = self.viewModel?.total
        if total != 0 {
            self.totalTextField.text = "\(total ?? 0.00)"
        }
        
        if let paidBy = self.viewModel?.paidBy, let name = paidBy.name {
            self.paidByButton.setTitle(name, for: .normal)
        }
        
        let date = self.viewModel?.date
        if date != 0 {
            let dateString = DateUtility.convertTimestampToString(withTimestamp: date ?? 0, format: DateFormat.type020)
            self.dateButton.setTitle(dateString, for: .normal)
        }
    }
    
    private func initRx() -> Void {
        setupTableViewRx()
        actionRx()
    }
    
    private func actionRx() -> Void {
        titleTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.title = this.titleTextField.text ?? ""
        }).disposed(by: disposeBag)
        
        descriptionTextView.rx.didChange.subscribe(onNext: { [weak self]_ in
            guard let this = self else { return }
            this.viewModel?.description = this.descriptionTextView.text ?? ""
        }).disposed(by: disposeBag)
        
        totalTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.total = Double(this.totalTextField.text ?? "0") ?? 0
            this.viewModel?.generateListData()
        }).disposed(by: disposeBag)
        
        paidByButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.performSegue(withIdentifier: this.presentSelectPersonViewSegue, sender: SelectMode.single)
        }).disposed(by: disposeBag)
        
        splitMethodButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.view.makeToast("Other methods will coming soon")
        }).disposed(by: disposeBag)
        
        dateButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.view.endEditing(true)
            this.showDatePicker()
        }).disposed(by: disposeBag)
        
        paidForButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.performSegue(withIdentifier: this.presentSelectPersonViewSegue, sender: SelectMode.multiple)
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.handleSaveBill()
        }).disposed(by: disposeBag)
    }
    
    func handleSaveBill() -> Void {
        let title = self.viewModel?.title ?? ""
        let desc = self.viewModel?.description ?? ""
        let date = self.viewModel?.date ?? 0
        let total = self.viewModel?.total ?? 0
        
        if title == "" {
            self.view.makeToast("Please input Bill title")
            return
        }
        
        if date == 0 {
            self.view.makeToast("Please choose Date")
            return
        }
        
        if total == 0 {
            self.view.makeToast("Please input bill total amount")
            return
        }
        
        guard let paidBy = self.viewModel?.paidBy else {
            self.view.makeToast("Please choose the person who paid this bill")
            return
        }
        
        guard let paidFor = self.viewModel?.paidFor, paidFor.count != 0 else {
            self.view.makeToast("Please choose list of perons who relative to this bill")
            return
        }
        
        let bill = Bill.initialize(title: title, total: total, desc: desc, paidBy: paidBy, date: date, paidFor: paidFor)
        if self.isUpdate {
            RealmManager.shared.update(bill: bill)
        } else {
            RealmManager.shared.add(object: bill)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker() -> Void {
        let datePickerView = DatePickerView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        datePickerView.date.value = DateUtility.convertStringToTimestamp(string: self.dateButton.titleLabel?.text ?? "", format: DateFormat.type020)
        datePickerView.handleShow(superView: self.view)
        datePickerView.date.asObservable().subscribe(onNext: { [weak self] (value) in
            guard let this = self else { return }
            this.viewModel?.date = value
            let dateString = DateUtility.convertTimestampToString(withTimestamp: value, format: DateFormat.type020)
            this.dateButton.setTitle(dateString, for: .normal)
        }).disposed(by: datePickerView.disposeBag)
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = BillDetailViewModel()
        }
    }
    
    private func setupTableViewRx() -> Void {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Object>>(
            configureCell: { [weak self] (ds, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: GenericTableViewCell002.cellIdentifier, for: indexPath) as! GenericTableViewCell002
                if let person = element as? Person, let model = self?.viewModel?.generatePersonCell(person: person) {
                    cell.initData(model: model)
                }
                cell.backgroundColor = UIColor.clear
                cell.iconButton.rx.tap.subscribe(onNext: { [weak self] _ in
                    guard let this = self else { return }
                    this.viewModel?.paidFor?.remove(at: indexPath.row)
                    this.viewModel?.generateListData()
                }).disposed(by: cell.disposeBag)
                
                return cell
            },titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
        })
        viewModel?.listData?.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.presentSelectPersonViewSegue, let vc = segue.destination as? SelectPersonViewController, let selectMode = sender as? SelectMode {
            vc.selectMode = selectMode
            vc.viewModel =  SelectPersonViewModel()
            if selectMode == .single {
                if let person = self.viewModel?.paidBy {
                    vc.viewModel?.selectedPersons.value.append(person)
                }
            } else {
                vc.viewModel?.selectedPersons.value = self.viewModel?.paidFor ?? []
            }
            
            vc.viewModel?.selectedPersons.asObservable().subscribe(onNext: { [weak self] (selectedPersons) in
                guard let this = self else { return }
                
                if selectMode == .single {
                    if selectedPersons.count > 0 {
                        this.viewModel?.paidBy = selectedPersons[0]
                        let name = selectedPersons[0].name ?? ""
                        this.paidByButton.setTitle(name, for: .normal)
                    }
                    
                } else {
                    this.viewModel?.paidFor = selectedPersons
                }
                
            }).disposed(by: disposeBag)
            vc.viewModel?.generateListData()
        }
    }

}

// MARK: - UITableViewDelegate
extension BillDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
