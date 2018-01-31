//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa


func firstObservable() {
    
    let observable1 = Observable<Int>.of(1,2,3)
    let replaySubject1 = ReplaySubject<String>.create(bufferSize: 3)
    replaySubject1.onNext("1")
    replaySubject1.onNext("2")
    replaySubject1.onNext("3")
    replaySubject1.onNext("4")
    
    replaySubject1.subscribe(onNext: {
        print($0)
    })
    replaySubject1.onNext("4")

}


firstObservable()
