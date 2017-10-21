//
//  CompletionHandler.swift
//  EasyTest
//
//  Created by Gilson Gil on 23/07/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

typealias CompletionHandlerType<T> = (() throws -> T) -> Void
