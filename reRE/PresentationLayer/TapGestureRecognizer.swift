//
//  TapGestureRecognizer.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

final class TapGestureRecognizer: UITapGestureRecognizer {
    var onTapped: (() -> Void)?
}
