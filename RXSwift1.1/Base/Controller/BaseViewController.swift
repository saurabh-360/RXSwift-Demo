//
//  BaseViewController.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 27/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindCollectionViewPresentation()
        bindCollectionViewSelection()
    }
    
    
    func setupView() {
        self.title = "Select Project"
    }
    
    
    func bindCollectionViewPresentation() {
        BaseViewModel().getProjectSections()
        .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "BaseCollectionViewCell", cellType: BaseCollectionViewCell.self)) {
                row, data, cell in
                cell.updateCellWithData(data: data)
            }.disposed(by: bag)
    
    }
    
    func bindCollectionViewSelection() {
        self.collectionView.rx.itemSelected
            .subscribe{row in
                print(row)
                if let indexpath = row.element {
                    let collectionCell = self.collectionView.cellForItem(at: indexpath) as? BaseCollectionViewCell
                    collectionCell?.updateSelectedColor(completion: { (bool) in
                        if bool {
                            self.navigateToViewController(row: indexpath.row)
                        }
                    })
                }
        }.disposed(by: bag)
    }
    
    func navigateToViewController(row: Int) {
        switch row {
        case 0:
            navigateToTableCollection()
            print(row)
        case 1,2,4...:
            print(row)
        case 3:
            navigateToCombinestagramController()
//        case 4:
//            print(row)
        default:
            print("something is exceeding our limits here")
        }
    }

    func navigateToCombinestagramController() {
        guard let controller = EnumStoryboard.combinestagram.instantiateViewController(withIdentifier: "CombinestagramViewController") as? CombinestagramViewController else {
            print("not able to initialize controller")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    func navigateToTableCollection() {
        guard let controller = EnumStoryboard.tableCollection.instantiateViewController(withIdentifier: "TableCollectionViewController") as? TableCollectionViewController else {
            print("not able to initialize controller")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}
