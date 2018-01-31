//
//  ViewController.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 15/01/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class cellTableView: UITableViewCell{
    @IBOutlet weak var cellTextField: UITextField!
}


class ViewController: UIViewController, UITableViewDelegate  {

    @IBOutlet weak var tfNormal: UITextField!
    @IBOutlet weak var tableview: UITableView!
    let observableCellsArray = Variable<[String]>([])
    let observableNormal = Variable.init("")

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfNormal.rx.text.orEmpty
            .bind(to: self.observableNormal)
            .disposed(by: disposeBag)

        
        var observable = Variable<[Countries]>([])
        observable =  ViewModel.getCountries()
        observable.asObservable().subscribe(onNext: {
            print($0)
        })
            .disposed(by: disposeBag)
        
        observable.value.append(contentsOf: ViewModel.getCountries().value)
        observable.asObservable().bind(to: self.tableview.rx.items(cellIdentifier: "cellTableView", cellType: cellTableView.self)) {
            row, element, cell in
            cell.cellTextField?.text = element.name
            }
            
            .disposed(by: disposeBag)
        
    }


    
}

extension ViewController {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cellTableView") as! cellTableView
//
//
//        cell.cellTextField.rx.text
//            .orEmpty
//            .bind(to: self.observableNormal)
//            .disposed(by: disposeBag)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("some")
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
}
