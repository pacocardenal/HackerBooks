//
//  Errors.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 30/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation

enum HackerBooksError : Error {
    
    case wrongURLFormatForJSONResource
    case wrongJSONFormat
    case nilJSONObject
    
}
