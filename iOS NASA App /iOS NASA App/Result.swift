//
//  Result.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation


//A generic completion handler
enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
