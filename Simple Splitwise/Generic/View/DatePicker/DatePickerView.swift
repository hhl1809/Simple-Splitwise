//
//  DatePickerView.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatePickerView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButtom: UIButton!
    @IBOutlet weak var doneButtom: UIButton!
    @IBOutlet var containView: UIView!
    @IBOutlet weak var datePickerContainView: UIView!
    @IBOutlet weak var darkView: UIView!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var date: Variable<Double> = Variable(0)
        
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    // MARK: - Functions
    func initView() {
        let bundle = Bundle.main
        bundle.loadNibNamed("DatePickerView", owner: self, options: nil)
        bundle.load()
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containView.backgroundColor = UIColor(red: 67, green: 67, blue: 67, alpha: 0.7)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        darkView.addGestureRecognizer(tapGesture)
        
        initRxAction()
    }
    
    @objc func handleDismiss() -> Void {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerContainView.transform =  CGAffineTransform(translationX: 0, y: 240)
            self.darkView.alpha = 0
        }, completion: { [weak self] (isComplete) in
            self?.removeFromSuperview()
        })
    }
    
    func handleShow(superView: UIView) -> Void {
        self.datePickerContainView.transform = CGAffineTransform(translationX: 0, y: 240)
        self.darkView.alpha = 0
        superView.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerContainView.transform = .identity
            self.darkView.alpha = 1
        }, completion: nil)
    }

    func initRxAction() -> Void {
        cancelButtom.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.handleDismiss()
        }).disposed(by: disposeBag)
        
        doneButtom.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            this.date.value = DateUtility.convertDateToTimestamp(withDate: this.datePicker.date)
            this.handleDismiss()
        }).disposed(by: disposeBag)
    }


}
