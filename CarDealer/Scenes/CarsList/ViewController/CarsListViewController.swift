//
//  CarsListViewController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import RxRelay
import RxSwift
import UIKit

final class CarsListViewController: UIViewController {

    let viewModel: CarsListViewModelViewActionsAndData

    init(viewModel: CarsListViewModelViewActionsAndData) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rootView = CarsListRootView()
    private let bag = DisposeBag()
    private let searchController = UISearchController()

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        title = "Cars"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        rootView.collectionView.setContentOffset(.init(x: 0, y: -300), animated: false)

        makeBindings()
    }

    private func makeBindings() {
        viewModel.viewActions.viewDidLoad.accept(Void())

        viewModel.viewData.sections
            .subscribe(onNext: { [weak self] sections in
                self?.rootView.collectionView.set(sections: sections, animatingDifferences: true)
            })
            .disposed(by: bag)
    }
}

extension CarsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.viewActions.searchInput.accept(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.viewActions.searchInput.accept(nil)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.viewActions.searchInput.accept(searchBar.text)
    }
}
