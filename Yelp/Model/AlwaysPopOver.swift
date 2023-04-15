//
//  AlwaysPopOver.swift
//  Yelp
//
//  Created by bari on 11/19/22.
//

import Foundation
import UIKit

func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
}

class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V:View {
    override func viewDidLoad() {
        super.viewDidLoad()

        let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        preferredContentSize = size
    }
}
