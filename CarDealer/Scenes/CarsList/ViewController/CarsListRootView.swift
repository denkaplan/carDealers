//
//  CarsListRootView.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import UIKit

final class CarsListRootView: UIView {

    let collectionView = CollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Pallete.backgroudPrimary
        addSubview(collectionView)
        collectionView.pin(to: self)
    }
}
