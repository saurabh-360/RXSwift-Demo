//
//  BaseCollectionViewCell.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 27/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!

    override func awakeFromNib() {
        borderView.dropShadow()
    }
    
    
    func updateCellWithData(data: BaseModel) {
        titleLabel.text = data.title
    }
    
    func updateSelectedColor(completion:  @escaping (_ bool: Bool) -> Void){
        UIView.animate(withDuration: 0.5, animations: {
            self.borderView.backgroundColor = UIColor.lightGray
        }) { (completed) in
            self.borderView.backgroundColor = UIColor.white
            completion(true)
        }
    }
    
    
    
}
