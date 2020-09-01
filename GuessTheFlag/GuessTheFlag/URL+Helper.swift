//
//  URL+Helper.swift
//  GuessTheFlag
//
//  Created by Arin Asawa on 8/28/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import Foundation
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
