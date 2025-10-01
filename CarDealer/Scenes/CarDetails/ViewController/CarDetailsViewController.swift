//
//  CarDetailsViewController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import RxRelay
import RxSwift
import UIKit

final class CarDetailsViewController: UIViewController {

    private let viewModel: CarDetailsViewModelViewActionsAndData
    private lazy var rootView = CarDetailsRootView()
    private let bag = DisposeBag()

    init(_ viewModel: CarDetailsViewModelViewActionsAndData) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        makeBindings()
    }

    private func makeBindings() {
        title = viewModel.viewData.carViewModel.brand
        rootView.bind(with: viewModel.viewData.carViewModel)
    }
}
