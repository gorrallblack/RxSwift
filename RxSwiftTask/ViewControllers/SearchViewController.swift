//
//  SearchViewController.swift

import UIKit

import RxSwift
import RxCocoa
import RxGesture

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBarBGView : UIView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let viewModel: SearchViewModal = SearchViewModal()
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        self.searchBar.searchTextField.placeholder = "Search Here"
        self.searchBar.searchTextField.clearButtonMode = .never
        
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.tableView.dataSource = nil
        self.loadResturantList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.dataSource = nil
    }
    
    func loadResturantList() {
        self.showCustomLoading()
        self.viewModel.loadResturantListFromServer {[weak self] isReload in
            guard let weakSelf = self else { return }
            weakSelf.dismissCustomLoading()
            if isReload {
                weakSelf.rxSetup()
            }
        }
    }
    
    func rxSetup(_ isSearch: Bool = false) {
        let results = self.viewModel.getFilteredResturantList()
            results.bind(to: tableView.rx.items(cellIdentifier: SearchViewModal.cellID,
                                            cellType: ResturantCell.self)) { row, model, cell in
                let userAvatarString : String = String(format: "%@", model.imageURL ?? "")
                cell.nameLabel.text = String(format: "%@", model.name!)
                cell.descriptionLabel.text = String(format: "%@", model.welcomeDescription!)
                cell.offerLabel.text = String(format: "%@", model.offer!)
                cell.resturantImageView.setImage(with: userAvatarString)
                cell.ratingView.isHidden = true
                cell.resturantImageView
                       .rx
                       .tapGesture()
                       .when(.recognized) // This is important!
                       .subscribe(onNext: { [weak self] _ in
                           guard let _ = self else { return }
                           print("ImageView is tapped")
                           cell.ratingView.isHidden = false
                       })
                       .disposed(by: self.bag)
                
                cell.selectionStyle = .none
        }.disposed(by: bag)
    }
    
    func showCustomLoading() {
        DispatchQueue.main.async {
            self.view.addSubview(UIView().customActivityIndicator(view: self.view,backgroundColor: UIColor.clear))
        }
    }

    func dismissCustomLoading() {
        DispatchQueue.main.async {
            self.view.subviews.last?.removeFromSuperview()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.viewModel.filteredResturantListArray = self.viewModel.resturantListArray
        }
        else {
            self.viewModel.filteredResturantListArray = []
            // you can do any kind of filtering here based on user input
            let searchedResturantItem : [ResturantData] = self.viewModel.resturantListArray.filter {
                (($0.name)?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            self.viewModel.filteredResturantListArray = searchedResturantItem
        }

        self.tableView.dataSource = nil
        self.rxSetup(false)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
