//
//  DispatchMain.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation

final class DispatchMain {
    static func async(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
