//
//  TableCollectionViewController.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 12/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct TableCollectionData {
    var title: String
    var collectionData: Variable<[CollectionData]>
}

struct CollectionData{
    var image: UIImage
}



class TableCollectionViewController: UIViewController {

    var tcData = Variable<[TableCollectionData]>([])
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createData()
        self.setupBinding()
        self.setupSelection()
        
//        var request = URLRequest.init(url: URL.init(string: "some url")!)
//        let dataObservable = URLSession.shared.rx.data(request: request)
//        dataObservable.observeOn(MainScheduler.instance)
//        .subscribe()
//        dataObservable.asObservable().subscribe(onNext: { response in
//            print(response)
//            print()
//            do {
//                let json = try? JSONSerialization.jsonObject(with: response, options: [])
//                print(json)
//            }
//            catch {
//
//            }
//        })
//            .disposed(by: disposeBag)
    }
    
    
    func setupSelection() {
        
        self.tableview.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.tableview.cellForRow(at: indexPath) as? TableCollectionTableViewCell
                cell?.tcCollectionView.rx.itemSelected
                    .subscribe(onNext: {[weak self] indexPathCollection in
                        print("\(indexPath.row), \(indexPathCollection.row)")
                    })
            }).disposed(by: disposeBag)
    }
//        self.tableview.rx.modelSelected(TableCollectionData.self)
//            .subscribe(onNext: {[weak self] tableData in
//                print(tableData)
//                let indexPath = self?.tableview.cellForRow(at: self?.tableview.rx.itemSelected)
//                let cell =  as! TableCollectionTableViewCell
//                cell
//
//            }).disposed(by: disposeBag)
//    }
    
    
    func collectionCellPressed(int: Int) {
        
    }
    
    
    func createData() {
        
        for i in 0...5 {
            let cdData11 = CollectionData.init(image: UIImage.init(named: "1")!)
            let cdData12 = CollectionData.init(image: UIImage.init(named: "2")!)
            let cdData13 = CollectionData.init(image: UIImage.init(named: "3")!)
            let cDDataVariable = Variable<[CollectionData]>([cdData11, cdData12, cdData13, cdData11, cdData12, cdData13])
            let tcData11 = TableCollectionData.init(title: "\(i)", collectionData: cDDataVariable)
            self.tcData.value.append(tcData11)
        }
    }
    
    func setupBinding() {
        
        tcData.asObservable().bind(to: self.tableview.rx.items(cellIdentifier: "TableCollectionTableViewCell", cellType: TableCollectionTableViewCell.self)) {
            row, tcDataObject, cell in
            cell.sectionLabel.text = tcDataObject.title
            tcDataObject.collectionData.asObservable().bind(to: cell.tcCollectionView.rx.items(cellIdentifier: "TableCollectionCollectionViewCell", cellType: TableCollectionCollectionViewCell.self)) {
                row, collectionObject, collectonCell in
                collectonCell.collectionImageView.image = collectionObject.image
                
            }.disposed(by: cell.disposeBag)
        }
            .disposed(by: disposeBag)
    }
    
}
