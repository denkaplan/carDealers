//
//  ImageLoader.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import SDWebImage
import RxSwift
import UIKit

struct Image {
    let url: URL
}

extension UIImageView {
    func setImageObservable(
        _ observable: Observable<UIImage?>,
        bag: DisposeBag
    ) {
        observable
            .subscribe(onNext: { [weak self] image in
                self?.performAnimatedTransition {
                    self?.image = image
                }
            })
            .disposed(by: bag)
    }

    func performAnimatedTransition(_ update: @escaping () -> Void) {
        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                update()
            },
            completion: nil
        )
    }
}

extension Image {
    func makeImageResultObservable(placeholder: UIImage? = nil) -> Observable<UIImage?> {
        Observable.create { observer -> Disposable in
            let operation = SDWebImageManager.shared.loadImage(
                with: url,
                options: [],
                progress: nil
            ) { image, data, error, cacheType, _, _ in
                if let image {
                    observer.onNext(image)
                } else {
                    observer.onNext(placeholder)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                operation?.cancel()
            }
        }
    }
}
