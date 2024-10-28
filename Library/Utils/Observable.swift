//
//  Observable.swift
//  Library
//
//  Created by Maxim on 25.10.2024.
//

import Foundation

final class Observable<Value> {

    struct Observer<ObserveredValue> {
        weak var observer: AnyObject?
        let block: (ObserveredValue) -> Void
    }

    private var observers = [Observer<Value>]()

    var value: Value {
        didSet { notifyObservers() }
    }

    init(_ value: Value) {
        self.value = value
    }

    func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }

    private func notifyObservers() {
        for observer in observers {
            observer.block(self.value)
        }
    }
}
