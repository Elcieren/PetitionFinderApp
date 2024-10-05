//
//  Petition.swift
//  Project7
//
//  Created by Eren Elçi on 4.10.2024.
//

import Foundation

struct Petition: Codable {
    var id: String
    var type: String
    var title: String
    var body: String
    var signatureCount: Int
}
