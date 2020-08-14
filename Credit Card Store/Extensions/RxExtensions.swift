//
//  RxExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType where Element: EventConvertible {

    /**
     Returns an observable sequence containing only next elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func elements() -> Observable<Element.Element> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }

    /**
     Returns an observable sequence containing only error elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func errors() -> Observable<Swift.Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }
}

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

func combineErrors(_ errors: Driver<Error>...) -> Driver<ErrorObject> {
    return Observable
        .merge(errors.map { $0.asObservable() })
        .map(ErrorHandlerStruct.handle)
        .asDriver(onErrorDriveWith: .never())
}
