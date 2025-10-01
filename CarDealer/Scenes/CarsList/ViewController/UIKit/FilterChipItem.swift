//
//  FilterChipItem.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 24.02.24.
//

import RxRelay
import RxSwift
import UIKit

struct FilterChipItem: TapableCollectionItem {
    struct ViewModel {
        let name: String
        let predicate: ((CarViewModel) -> Bool)
        let isSelected: BehaviorRelay<Bool>
    }

    func itemDidTapped() {
        viewModel.isSelected.accept(!viewModel.isSelected.value)
    }

    let viewModel: ViewModel

    var comparator: Comparator<ViewModel>? {
        .init(model: viewModel)
            .property(\.name)
            .property(\.isSelected.value)
    }

    var size: NSCollectionLayoutSize {
        .init(widthDimension: .estimated(60), heightDimension: .absolute(32))
    }
}

extension FilterChipItem {
    final class View: UIView, ContentView {
        private let textLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        func setHighlighted(_ isHighlighted: Bool) {
            scale(isHighlighted)
        }

        func setSelected(_ isSelected: Bool) {
            scale(isSelected)
        }

        private func scale(_ scale: Bool) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                self.transform = scale ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
        }

        private var bag = DisposeBag()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func prepareForReuse() {
            bag = DisposeBag()
        }

        private func setupUI() {
            addSubview(textLabel)
            layer.cornerRadius = 16
            backgroundColor = .systemGray.withAlphaComponent(0.3)

            NSLayoutConstraint.activate([
                textLabel.centerY.pinned(centerY),
                textLabel.left.pinned(left, 8),
                textLabel.right.pinned(right, -8)
            ])
        }

        func bind(with viewModel: ViewModel) {
            textLabel.text = viewModel.name

            viewModel.isSelected
                .subscribe(onNext: { [weak self] isSelected in
                    self?.textLabel.textColor = isSelected ? Pallete.backgroudPrimary : Pallete.onsurfacePrimary
                    self?.backgroundColor = isSelected ? Pallete.onsurfacePrimary : .systemGray.withAlphaComponent(0.3)
                })
                .disposed(by: bag)
        }
    }
}
