//
//  RequestInfo.swift
//  Compass
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation

enum RequestInfoState {
    case empty
    case error
    case loaded
    case loading
}

struct RequestInfo {
    let text: String
    var state: RequestInfoState
}
