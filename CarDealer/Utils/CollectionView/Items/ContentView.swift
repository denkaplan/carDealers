//
//  ContentView.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

protocol ContentView: UIView {
    associatedtype ViewModel

    func bind(with viewModel: ViewModel)

    func prepareForReuse()

    func setSelected(_ isSelected: Bool)
    func setHighlighted(_ isHighlighted: Bool)
}

extension ContentView {
    func prepareForReuse() {}
    func setSelected(_ isSelected: Bool) {}
    func setHighlighted(_ isHighlighted: Bool) {}
}
