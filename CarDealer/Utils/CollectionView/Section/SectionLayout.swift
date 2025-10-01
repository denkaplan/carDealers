//
//  SectionLayout.swift
//  Onfy
//
//  Created by Deniz Kaplan on 10/01/2023.
//

import UIKit

enum SectionLayout {
    case table(TableConfiguration)
    case verticalGrid(GridConfiguration)
    case carousel(Carousel.Configuration)
    case fullWidthCarousel(FullWidthCarousel.Configuration)
    case gridCarousel(GridCarousel.Configuration)
    case patternGrid(PatternGrid.Configuration)
    case custom(NSCollectionLayoutSection)
}
