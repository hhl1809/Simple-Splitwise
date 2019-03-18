//
//  GenericTableViewCell001.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/15/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct GenericTableViewCell001Model {
    
    // MARK: - Properties
    var title: String? = ""
    var titleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    var titleTextColor: UIColor? = UIColor.black
    var rightTitle: String? = ""
    var rightTitleFont: UIFont? = UIFont.systemFont(ofSize: 15)
    var rightTitleTextColor: UIColor? = UIColor.blue
    var subtitle: String? = ""
    var subtitleFont: UIFont? = UIFont.systemFont(ofSize: 14)
    var subtitleTextColor: UIColor? = UIColor.lightGray
    var object: Any?
    var cellName: String? = ""
    var imageName: String? = ""
    var isSelect: Bool = false
    
    // MARK: - Init
    init(title: String, titleFont: UIFont = UIFont.systemFont(ofSize: 16), titleTextColor: UIColor = UIColor.black, rightTitle: String, rightTitleFont: UIFont = UIFont.systemFont(ofSize: 15), rightTitleTextColor: UIColor = UIColor.blue, subtitle: String, subtitleFont: UIFont = UIFont.systemFont(ofSize: 14), subtitleTextColor: UIColor = UIColor.lightGray, object: Any? = nil, cellName: String, imageName: String, isSelect: Bool = false) {
        self.title = title
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.rightTitle = rightTitle
        self.rightTitleFont = rightTitleFont
        self.rightTitleTextColor = rightTitleTextColor
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont
        self.subtitleTextColor = subtitleTextColor
        self.object = object
        self.cellName = cellName
        self.imageName = imageName
        self.isSelect = isSelect
    }
}

class GenericTableViewCell001: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Properties
    static let cellIdentifier = "GenericTableViewCell001"
    var object: Any?
    var cellName: String = ""
    var isSelect: Bool = false
    var disposeBag = DisposeBag()
    
    // MARK: - Functions
    func initData(model: GenericTableViewCell001Model) -> Void {
        titleLabel.text = model.title ?? ""
        titleLabel.textColor = model.titleTextColor ?? UIColor.black
        titleLabel.font = model.titleFont ?? UIFont.systemFont(ofSize: 16)
        rightLabel.text = model.rightTitle ?? ""
        rightLabel.textColor = model.rightTitleTextColor ?? UIColor.blue
        rightLabel.font = model.rightTitleFont ?? UIFont.systemFont(ofSize: 15)
        subtitleLabel.text = model.subtitle ?? ""
        subtitleLabel.textColor = model.subtitleTextColor ?? UIColor.lightGray
        subtitleLabel.font = model.subtitleFont ?? UIFont.systemFont(ofSize: 14)
        object = model.object
        cellName = model.cellName ?? ""
        iconView.image = UIImage(named: model.imageName ?? "") ?? UIImage()
        isSelect = model.isSelect
    }
}
