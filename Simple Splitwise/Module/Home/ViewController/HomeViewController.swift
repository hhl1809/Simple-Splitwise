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
        
        self.viewModel?.generateListPerson()
        self.viewModel?.filterListPersonByAlphabet()
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
                
            }
            
        }).disposed(by: disposeBag)
        
        segmentedControl.rx.value.subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
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
                if let person = element as? Person, let model = self?.viewModel?.generatePersonCell(person: person) {
                    cell.initData(model: model)
                }
                return cell
        },titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        })
        viewModel?.listData?.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = HomeViewModel()
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

