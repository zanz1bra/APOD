//
//  APODModel.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import Foundation

struct APOD: Codable {
    let date: String
    let title: String
    let explanation: String
    let hdurl: String
    let copyright: String
//    let date: String?
}
