//
//  DecodeUtil.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation

struct DecodeUtil {
    static private let decoder = JSONDecoder()
    
    static func decode<T: Decodable>(_ type: T.Type, data: Data) -> T? {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(type, from: data)
    }
}
