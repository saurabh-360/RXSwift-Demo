//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

var start = 0
func getStartNumber() -> Int {
    start += 1
    return start
}

let numbers = Observable<Int>.create { observer in
    let start = getStartNumber()
    observer.onNext(start)
    observer.onNext(start+1)
    observer.onNext(start+2)
    observer.onCompleted()
    return Disposables.create()
}

let some = numbers.asObservable().share()

some.subscribe({
    print($0)
})

some.subscribe({
    print($0)
})
