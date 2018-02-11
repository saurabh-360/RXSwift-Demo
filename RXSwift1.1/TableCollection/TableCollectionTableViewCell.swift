//
//  TableCollectionTableViewCell.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 12/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var tcCollectionView: UICollectionView!
    @IBOutlet weak var sectionLabel: UILabel!
    private(set) var disposeBag = DisposeBag()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tcCollectionView.rx.itemSelected
            .subscribe(onNext: {indexPathCollection in
                print("\(indexPathCollection.row)")
            })
            .disposed(by: self.disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        self.tcCollectionView.rx.itemSelected
            .subscribe(onNext: {indexPathCollection in
                print("\(indexPathCollection.row)")
            })
            .disposed(by: self.disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
