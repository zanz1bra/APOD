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
    let url: String
    let copyright: String
}
