//
//  Logger.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation
import CocoaLumberjack

#if RELEASE
@inline(__always)
public func LogDebug(_ item: Any, functionName: StaticString = #function, fileName: StaticString = #file, line: UInt = #line) {
}
@inline(__always)
public func LogError(_ item: Any, functionName: StaticString = #function, fileName: StaticString = #file, line: UInt = #line) {
}
#else
@inline(__always)
public func LogDebug(_ item: Any,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     line: UInt = #line) {
    DDLogVerbose(String(describing: item), file: fileName, function: functionName, line: line)
    print("==================start===================")
    dump(fileName)
    dump(functionName)
    dump(line)
    
    if let data = item as? Data {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            dump(json)
        } catch {
            dump(item)
        }
    } else {
        dump(item)
    }
    
    print("==================end===================")
}
@inline(__always)
public func LogError(_ item: Any,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     line: UInt = #line) {
    DDLogError(String(describing: item), file: fileName, function: functionName, line: line)
    print("==================start===================")
    dump(fileName)
    dump(functionName)
    dump(line)
    dump(item)
    print("==================end===================")
}

#endif
