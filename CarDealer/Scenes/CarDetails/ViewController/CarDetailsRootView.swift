//
//  CarDetailsRootView.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxSwift
import UIKit

final class CarDetailsRootView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Pallete.onsurfaceSecondary
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Pallete.onsurfaceSecondary.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Pallete.onsurfaceSecondary
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let fuelInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Pallete.onsurfaceSecondary
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Fuel type"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let modelYearInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Pallete.onsurfaceSecondary
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Year"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let fuelValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let yearValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .left
        label.text = "Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with viewModel: CarViewModel) {
        subtitleLabel.text = viewModel.model
        yearValueLabel.text = viewModel.yearString
        fuelValueLabel.text = viewModel.fuel
        priceValueLabel.text = viewModel.priceString

        imageView.setImageObservable(
            viewModel.image.makeImageResultObservable(),
            bag: bag
        )
    }

    private func setupUI() {
        backgroundColor = Pallete.backgroudPrimary

        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(imageView)
        containerView.addSubview(modelYearInfoLabel)
        containerView.addSubview(yearValueLabel)
        containerView.addSubview(fuelInfoLabel)
        containerView.addSubview(fuelValueLabel)
        containerView.addSubview(priceInfoLabel)
        containerView.addSubview(priceValueLabel)

        NSLayoutConstraint.activate([
            scrollView.top.pinned(safeAreaLayoutGuide.top),
            scrollView.left.pinned(left),
            scrollView.right.pinned(right),
            scrollView.bottom.pinned(bottom),

            subtitleLabel.left.pinned(left, 16),
            subtitleLabel.top.pinned(containerView.top, 2),

            imageView.top.pinned(subtitleLabel.bottom, 16),
            imageView.left.pinned(left, 16),
            imageView.width.withValue(200),
            imageView.height.withValue(200),

            containerView.top.pinned(scrollView.top),
            containerView.left.pinned(scrollView.left),
            containerView.width.pinned(scrollView.width),
            containerView.bottom.pinned(scrollView.bottom),

            modelYearInfoLabel.left.pinned(left, 16),
            modelYearInfoLabel.top.pinned(imageView.bottom, 16),
            yearValueLabel.left.pinned(modelYearInfoLabel.right, 6),
            yearValueLabel.bottom.pinned(modelYearInfoLabel.bottom),

            fuelInfoLabel.left.pinned(left, 16),
            fuelInfoLabel.top.pinned(modelYearInfoLabel.bottom, 8),
            fuelValueLabel.left.pinned(fuelInfoLabel.right, 6),
            fuelValueLabel.bottom.pinned(fuelInfoLabel.bottom),

            priceInfoLabel.left.pinned(left, 16),
            priceInfoLabel.top.pinned(fuelInfoLabel.bottom, 8),
            priceValueLabel.left.pinned(priceInfoLabel.right, 6),
            priceValueLabel.bottom.pinned(priceInfoLabel.bottom),
            priceInfoLabel.bottom.pinned(containerView.bottom, -300),
        ])
    }
}
