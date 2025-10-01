//
//  CollectionViewInteractionHandler.swift
//  Onfy
//
//  Created by Deniz Kaplan on 03.04.23.
//

import RxRelay
import UIKit

protocol CollectionViewInteractionHandler: AnyObject {
    var interactionRelay: PublishRelay<Void> { get }
}

final class CollectionViewInteractionHandlerImpl: CollectionViewInteractionHandler {
    let interactionRelay = PublishRelay<Void>()
}
