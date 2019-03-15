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
        
        initViewModel()
        initRx()
        setupView()
    }
    
    // MARK: - Functions
    private func initRx() -> Void {
        actionRx()
    }
    
    private func actionRx() -> Void {
        addButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.performSegue(withIdentifier: this.presentAddPersonViewSegue, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    private func setupView() -> Void {
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.setShadow(cornerRadius: addButton.layer.cornerRadius)
        addButton.setImage(UIImage(named: APP_IMAGE.ADD_PERSON)?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.imageView?.tintColor = UIColor.white
    }
    
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = HomeViewModel()
        }
    }
    
    // MARK: - Navigation

}

