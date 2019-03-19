//
//  HomeViewController.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/12/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: HomeViewModel?
    var presentAddPersonViewSegue = "presentAddPersonView"
    var presentAddBillViewSegue = "presentAddBillView"
    var pushToPersonDetailSegue = "pushToPersonDetail"
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        registerCells()
        initViewModel()
        initRx()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.generateListBill()
        self.viewModel?.generateListPerson()
        self.viewModel?.generateListData(index: self.segmentedControl.selectedSegmentIndex)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    private func registerCells() -> Void {
        tableView.register(UINib(nibName: GenericTableViewCell001.cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: GenericTableViewCell001.cellIdentifier)
    }
    
    private func initRx() -> Void {
        setupTableViewRx()
        actionRx()
    }
    
    private func actionRx() -> Void {
        addButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            if this.segmentedControl.selectedSegmentIndex == 0 {
                this.performSegue(withIdentifier: this.presentAddPersonViewSegue, sender: nil)
            } else {
                this.performSegue(withIdentifier: this.presentAddBillViewSegue, sender: nil)
            }
            
        }).disposed(by: disposeBag)
        
        segmentedControl.rx.value.subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            this.viewModel?.generateListData(index: this.segmentedControl.selectedSegmentIndex)
            if this.segmentedControl.selectedSegmentIndex == 0 {
                this.addButton.setImage(UIImage(named: APP_IMAGE.ADD_PERSON)?.withRenderingMode(.alwaysTemplate), for: .normal)
                this.addButton.imageView?.tintColor = UIColor.white
            } else {
                this.addButton.setImage(UIImage(named: APP_IMAGE.BILL)?.withRenderingMode(.alwaysTemplate), for: .normal)
                this.addButton.imageView?.tintColor = UIColor.white
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() -> Void {
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.setShadow(cornerRadius: addButton.layer.cornerRadius)
        addButton.setImage(UIImage(named: APP_IMAGE.ADD_PERSON)?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.imageView?.tintColor = UIColor.white

        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
    }
    
    private func setupTableViewRx() -> Void {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Object>>(
            configureCell: { [weak self] (ds, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: GenericTableViewCell001.cellIdentifier, for: indexPath) as! GenericTableViewCell001
                if self?.segmentedControl.selectedSegmentIndex == 0 {
                    if let person = element as? Person, let model = self?.viewModel?.generatePersonCell(person: person) {
                        cell.initData(model: model)
                    }
                } else {
                    if let bill = element as? Bill, let model = self?.viewModel?.generateBillCell(bill: bill) {
                        cell.initData(model: model)
                    }
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
                if this.segmentedControl.selectedSegmentIndex == 0 {
                    if let person = object as? Person {
                        this.performSegue(withIdentifier: this.pushToPersonDetailSegue, sender: person)
                    }
                } else {
                    if let bill = object as? Bill {
                        this.performSegue(withIdentifier: this.presentAddBillViewSegue, sender: bill)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = HomeViewModel()
        }
    }
    
    // MARK: - Navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.presentAddBillViewSegue, let vc = segue.destination as? BillDetailViewController, let bill = sender as? Bill {
            vc.viewModel = BillDetailViewModel()
            vc.viewModel?.isUpdate = true
            vc.viewModel?.date = bill.date
            vc.viewModel?.title = bill.title ?? ""
            vc.viewModel?.description = bill.desc ?? ""
            vc.viewModel?.total = bill.total
            vc.viewModel?.bill = bill
            if let paidBy = bill.paidBy {
                vc.viewModel?.paidBy = paidBy
            }
            
            if let paidFor = bill.paidFor {
                for person in paidFor {
                    vc.viewModel?.paidFor?.append(person)
                }
            }
            vc.viewModel?.generateListData()
            
        } else if segue.identifier == self.pushToPersonDetailSegue, let vc = segue.destination as? PersonDetailViewController, let person = sender as? Person {
            vc.initViewModel(person: person)

        }
    }

}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

