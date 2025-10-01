//
//  CarsListViewModel.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import RxSwift
import RxRelay
import Foundation

final class CarsListViewModel: CarsListViewModelProtocol {
    
    private let getCarsListUseCase: GetCarsListUseCase
    private let bag = DisposeBag()

    init(getCarsListUseCase: GetCarsListUseCase) {
        self.getCarsListUseCase = getCarsListUseCase

        makeBindings()
    }

    var input: CarsListViewModelInput = .init()
    private let carSelectedRelay = PublishRelay<CarViewModel>()

    private(set) lazy var output: CarsListViewModelOutput = .init(didSelectCar: carSelectedRelay.asObservable())

    var viewActions: CarsListViewModelViewActions = .init()

    var viewData: CarsListViewModelViewData = .init()

    private lazy var carsSection = CollectionSection(
        id: UUID().uuidString,
        layout: .table(.plain()),
        items: []
    )

    // Mock static data
    private let filters: [FilterChipItem] = [
        FilterChipItem(
            viewModel: .init(
                name: "Brand new",
                predicate: {
                    $0.yearString == "2024"
                },
                isSelected: .init(value: false)
            )
        ),
        FilterChipItem(
            viewModel: .init(
                name: "German",
                predicate: {
                    $0.brand == "Volkswagen"
                    || $0.brand == "Audi"
                    || $0.brand == "BMW"
                    || $0.brand == "Mercedes Benz"
                },
                isSelected: .init(value: false)
            )
        ),
        FilterChipItem(
            viewModel: .init(
                name: "Electric",
                predicate: { $0.fuel == "Electric" },
                isSelected: .init(value: false)
            )
        ),
        FilterChipItem(
            viewModel: .init(
                name: "Sport cars",
                predicate: {
                    $0.fuel == "Gasoline"
                    && ($0.brand == "Porsche"
                        || $0.brand == "BMW"
                        || $0.brand == "Aston Martin"
                        || $0.brand == "BMW")
                },
                isSelected: .init(value: false)
            )
        ),
        FilterChipItem(
            viewModel: .init(
                name: "Japan",
                predicate: {
                    $0.brand == "Toyota" || $0.brand == "Honda"
                },
                isSelected: .init(value: false)
            )
        )
    ]

    private var filtersSection = CollectionSection(
        id: UUID().uuidString ,
        layout: .carousel(.init(spacing: 12, paging: false)),
        items: [],
        configuration: .init(contentInsets: .init(top: 0, leading: 16, bottom: 0, trailing: 16))
    )

    private var carItems = [CarViewModel]()

    private func makeBindings() {
        viewActions.searchInput
            .debounce(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] searchInput in
                guard let self else { return }
                updateSection(with: applySearchInput(searchInput), filters: self.filters)
            })
            .disposed(by: bag)

        viewActions.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.loadData()
            })
            .disposed(by: bag)


        filters.forEach { filter in
            filter.viewModel.isSelected
                .asObservable()
                .subscribe(onNext: { [weak self] isSelected in
                    guard let self else { return }
                    guard let currentIndex = filters.firstIndex(where: { $0.viewModel.name == filter.viewModel.name }) else { return }
                    if isSelected {
                        filters.enumerated().forEach {
                            if $0.element.viewModel.isSelected.value {
                                if $0.offset != currentIndex {
                                    $0.element.viewModel.isSelected.accept(false)
                                }
                            }
                        }
                    }
                    self.updateSection(
                        with: applySearchInput(self.viewActions.searchInput.value),
                        filters: filters
                    )
                })
                .disposed(by: bag)

            filtersSection.items = filters
        }
    }

    private func loadData() {
        getCarsListUseCase.execute()
            .do(onNext: { [weak self] items in
                self?.carItems = items
            })
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                self.updateSection(with: items, filters: self.filters)
            })
            .disposed(by: bag)
    }

    private func updateSection(
        with items: [CarViewModel],
        filters: [FilterChipItem]
    ) {
        var carsSection = carsSection
        var filtersSection = filtersSection
        filtersSection.items = filters
        var items = items
        if let selectedFilter = filters.first(where: { $0.viewModel.isSelected.value }) {
            items = items.filter(selectedFilter.viewModel.predicate)
        }
        carsSection.items = items.map { item in
            CarItem(
                viewModel: .init(
                    manufacturer: item.brand,
                    model: item.model,
                    year: item.yearString,
                    fuel: item.fuel,
                    priceString: item.priceString,
                    image: item.image,
                    tapObserver: .init(eventHandler: { [weak self] _ in
                        self?.carSelectedRelay.accept(item)
                    })
                )
            )
        }
        viewData.sections.accept([filtersSection, carsSection])
    }
}

private extension CarsListViewModel {
    private func applySearchInput(_ searchInput: String?) -> [CarViewModel] {
        guard let searchInput, !searchInput.isEmpty else {
            return self.carItems
        }
        return self.carItems.filter { item in
            for subStr in searchInput.components(separatedBy: " ") {
                if item.contains(subStr) {
                    return true
                }
            }
            return false
        }
    }
}
