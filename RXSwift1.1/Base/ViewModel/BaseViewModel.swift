//
//  BaseViewModel.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 27/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel: NSObject {
    
    func getProjectSections() -> Observable<[BaseModel]>{
        
        let project0 = BaseModel.init(title: "Collection view in TableView")
        let project1 = BaseModel.init(title: "Observables")
        let project2 = BaseModel.init(title: "Operators")
        let project3 = BaseModel.init(title: "Combinestagram")
        let project4 = BaseModel.init(title: "Networking")
        let project5 = BaseModel.init(title: "RXRealm")
        
        return Observable.of([project0,
                              project1,
                              project2,
                              project3,
                              project4,
                              project5])
    }
}
