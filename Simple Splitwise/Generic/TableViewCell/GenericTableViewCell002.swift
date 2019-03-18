//
//  GenericTableViewCell002.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct GenericTableViewCell002Model {
    
    // MARK: - Properties
    var title: String? = ""
    var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    var titleTextColor: UIColor? = UIColor.black
    var inputText: String? = ""
    var inputTextFont: UIFont? = UIFont.systemFont(ofSize: 16)
    var inputTextColor: UIColor? = UIColor.black
    var rightTitle: String? = ""
    var rightTitleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    var rightTitleTextColor: UIColor? = UIColor.black
    var object: Any?
    var cellName: String? = ""
    var imageName: String? = ""
    
    // MARK: - Init
    init(title: String, titleFont: UIFont = UIFont.systemFont(ofSize: 16), titleTextColor: UIColor = UIColor.black, inputText: String, inputTextFont: UIFont = UIFont.systemFont(ofSize: 16), inputTextColor: UIColor = UIColor.black, rightTitle: String, rightTitleFont: UIFont = UIFont.systemFont(ofSize: 16), rightTitleTextColor: UIColor = UIColor.black, object: Any? = nil, cellName: String, imageName: String) {
        self.title = title
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.rightTitle = rightTitle
        self.rightTitleFont = rightTitleFont
        self.rightTitleTextColor = rightTitleTextColor
        self.object = object
        self.cellName = cellName
        self.imageName = imageName
        self.inputText = inputText
        self.inputTextFont = inputTextFont
        self.inputTextColor = inputTextColor
    }
}

class GenericTableViewCell002: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Properties
    static let cellIdentifier = "GenericTableViewCell002"
    var object: Any?
    var cellName: String = ""
    var disposeBag = DisposeBag()
    
    // MARK: - Functions
    func initData(model: GenericTableViewCell002Model) -> Void {
        titleLabel.text = model.title ?? ""
        titleLabel.textColor = model.titleTextColor ?? UIColor.black
        titleLabel.font = model.titleFont ?? UIFont.systemFont(ofSize: 16)
        rightLabel.text = model.rightTitle ?? ""
        rightLabel.textColor = model.rightTitleTextColor ?? UIColor.black
        rightLabel.font = model.rightTitleFont ?? UIFont.systemFont(ofSize: 16)
        inputTextField.text = model.inputText ?? ""
        inputTextField.textColor = model.inputTextColor ?? UIColor.black
        inputTextField.font = model.inputTextFont ?? UIFont.systemFont(ofSize: 16)
        object = model.object
        cellName = model.cellName ?? ""
        let image = UIImage(named: model.imageName ?? "")
        iconButton.setImage(image, for: .normal)
    }
}
