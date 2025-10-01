//
//  CarCell.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import SDWebImage
import RxSwift
import UIKit

struct CarItem: TapableCollectionItem {
    struct ViewModel {
        let manufacturer: String
        let model: String
        let year: String
        let fuel: String
        let priceString: String
        let image: Image
        let tapObserver: AnyObserver<Void>
    }

    func itemDidTapped() {
        viewModel.tapObserver.onNext(Void())
    }

    let viewModel: ViewModel

    var comparator: Comparator<ViewModel>? {
        .init(model: viewModel)
            .property(\.model)
            .property(\.manufacturer)
    }

    var size: NSCollectionLayoutSize {
        .fullWidth(126)
    }
}

extension CarItem {
    final class View: UIView, ContentView {
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = Pallete.onsurfaceSecondary.withAlphaComponent(0.3)
            imageView.layer.cornerRadius = 14
            imageView.layer.masksToBounds = true
            return imageView
        }()

        private let brandLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 21)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let textLabel: UILabel = {
            let label = UILabel()
            label.textColor = Pallete.onsurfaceSecondary
            label.font = UIFont.systemFont(ofSize: 17)
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let priceLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let fuelLabel: UILabel = {
            let label = UILabel()
            label.textColor = Pallete.onsurfaceSecondary
            label.font = UIFont.systemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let yearLabel: UILabel = {
            let label = UILabel()
            label.textColor = Pallete.onsurfaceSecondary
            label.font = UIFont.systemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        func setHighlighted(_ isHighlighted: Bool) {
            animateHighlight(isHighlighted)
        }

        func setSelected(_ isSelected: Bool) {
            animateHighlight(isSelected)
        }

        private func animateHighlight(_ flag: Bool) {
            alpha = flag ? 0.7 : 1.0
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
            textLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            brandLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            brandLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            addSubview(imageView)
            addSubview(brandLabel)
            addSubview(textLabel)
            addSubview(priceLabel)
            addSubview(yearLabel)
            addSubview(fuelLabel)

            NSLayoutConstraint.activate([
                imageView.centerY.pinned(centerY),
                imageView.left.pinned(left, 16),
                imageView.widthAnchor.withValue(76),
                imageView.heightAnchor.withValue(76),

                brandLabel.left.pinned(imageView.right, 12),
                brandLabel.top.pinned(top, 12),

                textLabel.firstBaseline.pinned(brandLabel.firstBaseline),
                textLabel.left.pinned(brandLabel.right, 6),
                textLabel.right.pinned(right, -12),

                yearLabel.top.pinned(brandLabel.bottom, 2),
                yearLabel.left.pinned(imageView.right, 12),
                yearLabel.right.pinned(right, -12),

                fuelLabel.top.pinned(yearLabel.bottom, 2),
                fuelLabel.left.pinned(imageView.right, 12),
                fuelLabel.right.pinned(right, -12),

                priceLabel.top.pinned(fuelLabel.bottom, 2),
                priceLabel.left.pinned(imageView.right, 12),
                priceLabel.right.pinned(right, -12),
                priceLabel.bottom.pinned(bottom, -12)
            ])
        }

        func bind(with viewModel: ViewModel) {
            brandLabel.text = viewModel.manufacturer
            textLabel.text = viewModel.model
            priceLabel.text = viewModel.priceString
            yearLabel.text = viewModel.year
            fuelLabel.text = viewModel.fuel

            imageView.setImageObservable( viewModel.image.makeImageResultObservable(), bag: bag)
        }
    }
}
