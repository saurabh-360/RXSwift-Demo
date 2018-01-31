//
//  ViewModel.swift
//  RXSwift1.1
//
//  Created by Saurabh on 31/01/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct Countries {
    var name = ""
    var id = ""
}
class ViewModel: NSObject {

    class func getCountries() -> Variable<[Countries]> {
        
        let someObserver = Variable<[Countries]>([])
        
        someObserver.value.append(Countries.init(name: "abc", id: "1"))
        someObserver.value.append(Countries.init(name: "def", id: "2"))
        return someObserver
    }
}
