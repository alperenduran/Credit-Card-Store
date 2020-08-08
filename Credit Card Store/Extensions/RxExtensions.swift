//
//  RxExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable {
    static func pipe() -> (observer: AnyObserver<Element>, observable: Observable<Element>) {
        let subject = PublishSubject<Element>()
        return (subject.asObserver(), subject.asObservable())
    }

    static func sharedPipe() -> (observer: AnyObserver<Element>, observable: Observable<Element>) {
        let subject = BehaviorSubject(value: nil as Element?)

        let observer = AnyObserver.init { (event: Event<Element>) in
            switch event {
            case .completed:
                subject.onCompleted()
            case .error(let error):
                subject.onError(error)
            case .next(let element):
                subject.onNext(element)
            }
        }

        let observable = subject
            .asObservable()
            .compactMap { $0 }
        
        return (observer, observable)
    }
}

extension Driver {
    static func pipe() -> (observer: AnyObserver<Element>, driver: Driver<Element>) {
        let subject = PublishSubject<Element>()
        return (subject.asObserver(), subject.asDriver(onErrorDriveWith: .never()))
    }

    static func sharedPipe() -> (observer: AnyObserver<Element>, driver: Driver<Element>) {
        let subject = BehaviorSubject(value: nil as Element?)

        let observer = AnyObserver.init { (event: Event<Element>) in
            switch event {
            case .completed:
                subject.onCompleted()
            case .error(let error):
                subject.onError(error)
            case .next(let element):
                subject.onNext(element)
            }
        }

        let driver = subject.asObservable().compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())

        return (observer, driver)
    }
}

extension Observable {
    func waitWithLatestFrom<Source>(_ second: Source) -> Observable<Source.Element>
        where Source : ObservableConvertibleType {

        let stream1 = self.withLatestFrom(second)
        let stream2 = Observable<Source.Element>
            .combineLatest(self, second.asObservable(), resultSelector: { a, b in b })

        return stream1.amb(stream2)
    }

    func waitWithLatestFrom<Source, ResultType>(_ second: Source, resultSelector: @escaping (Element, Source.Element) throws -> ResultType) -> Observable<ResultType> where Source : ObservableConvertibleType {
        let stream1 = self.withLatestFrom(second, resultSelector: resultSelector)
        let stream2 = Observable<ResultType>
            .combineLatest(self, second.asObservable(), resultSelector: resultSelector)

        return stream1.amb(stream2)
    }
}
