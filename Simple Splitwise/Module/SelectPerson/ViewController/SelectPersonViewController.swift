//
//  SelectPersonViewController.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class SelectPersonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: SelectPersonViewModel?
    var selectMode: SelectMode = .single
    
     // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        initViewModel()
        initRx()
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
        cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.viewModel?.selectedPersons.value.removeAll()
            for cell in this.tableView.visibleCells {
                if let cell = cell as? GenericTableViewCell001, cell.isSelect, let person = cell.object as? Person {
                     this.viewModel?.selectedPersons.value.append(person)
                }
            }
            this.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    private func setupTableViewRx() -> Void {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Object>>(
            configureCell: { [weak self] (ds, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: GenericTableViewCell001.cellIdentifier, for: indexPath) as! GenericTableViewCell001
                let isSelect = cell.isSelect
                if let person = element as? Person, let model = self?.viewModel?.generatePersonCell(person: person) {
                    cell.initData(model: model)
                    cell.isSelect = isSelect
                }
                if cell.isSelect {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
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
                if let cell = this.tableView.cellForRow(at: indexPath) as? GenericTableViewCell001 {
                    this.handleSelectMode(cell: cell)
                }
            }).disposed(by: disposeBag)
    }
    
    func handleSelectMode(cell: GenericTableViewCell001) -> Void {
        if self.selectMode == .single {
            for tableViewCell in self.tableView.visibleCells {
                if let tableViewCell = tableViewCell as? GenericTableViewCell001 {
                    tableViewCell.isSelect = false
                }
            }
        }
        
        cell.isSelect = !cell.isSelect
        
        if cell.isSelect {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        self.viewModel?.reloadData()
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = SelectPersonViewModel()
        }
    }


}

// MARK: - UITableViewDelegate
extension SelectPersonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
