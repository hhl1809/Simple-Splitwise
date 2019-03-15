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
    var subtitle: String? = ""
    var subtitleFont: UIFont? = UIFont.systemFont(ofSize: 16)
    var subtitleTextColor: UIColor? = UIColor.black
    var object: Any?
    var cellName: String? = ""
    var imageName: String? = ""
    
    // MARK: - Init
    init(title: String, titleFont: UIFont = UIFont.systemFont(ofSize: 16), titleTextColor: UIColor = UIColor.black, subtitle: String, subtitleFont: UIFont = UIFont.systemFont(ofSize: 14), subtitleTextColor: UIColor = UIColor.lightGray, object: Any? = nil, cellName: String, imageName: String) {
        self.title = title
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont
        self.subtitleTextColor = subtitleTextColor
        self.object = object
        self.cellName = cellName
        self.imageName = imageName
    }
}

class GenericTableViewCell001: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Properties
    static let cellIdentifier = "GenericTableViewCell001"
    var object: Any?
    var cellName: String = ""
    
    // MARK: - Functions
    func initData(model: GenericTableViewCell001Model) -> Void {
        titleLabel.text = model.title ?? ""
        titleLabel.textColor = model.titleTextColor ?? UIColor.black
        titleLabel.font = model.titleFont ?? UIFont.systemFont(ofSize: 16)
        subtitleLabel.text = model.subtitle ?? ""
        subtitleLabel.textColor = model.subtitleTextColor ?? UIColor.lightGray
        subtitleLabel.font = model.subtitleFont ?? UIFont.systemFont(ofSize: 14)
        object = model.object
        cellName = model.cellName ?? ""
        iconView.image = UIImage(named: model.imageName ?? "") ?? UIImage()
    }
}
