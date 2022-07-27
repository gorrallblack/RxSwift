//
//  SearchViewModal.swift

import Foundation
import RxSwift
import RxCocoa

class SearchViewModal : CustomSearchViewModel <[ResturantData]> {
    static let cellID = "ResturantCell"
    
    var resturantListArray : [ResturantData] = [ResturantData]()
    var filteredResturantListArray : [ResturantData] = [ResturantData]()
    var selectedIndex = 0
    
    func getResturantList() -> Observable<[ResturantData]> {
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(self.resturantListArray)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func loadResturantListFromServer(completionHandler: @escaping(_ isReload: Bool) -> Void) {
        Requests.fetchResturantList {[weak self] success, resturantList in
            guard let self = self else { return }
            if success {
                self.resturantListArray.removeAll()
                self.resturantListArray.append(contentsOf: resturantList)
                
                self.filteredResturantListArray.removeAll()
                self.filteredResturantListArray.append(contentsOf: resturantList)
                
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    func getFilteredResturantList() -> Observable<[ResturantData]> {
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(self.filteredResturantListArray)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func selectedSegmentIndex(selectedIndex : Int) {
        self.selectedIndex = selectedIndex
    }
}

class CustomSearchViewModel<T> {
    // inputs
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
     
    // outputs
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject
            .asDriver(onErrorJustReturn: false)
    }

    private let errorSubject = PublishSubject<SearchError?>()
    var error: Driver<SearchError?> {
        return errorSubject
            .asDriver(onErrorJustReturn: SearchError.unkowned)
    }

    private let contentSubject = PublishSubject<[T]>()
    var content: Driver<[T]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
}
