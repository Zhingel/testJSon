//
//  user.swift
//  testJSon
//
//  Created by Стас Жингель on 02.09.2021.
//

import Foundation

struct User: Codable {
    var name: String
    var job: String
    var id: String
    var createdAt: Date?
    var modifiedDateCreated: String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        if let newDate = createdAt {
            return dateFormater.string(from: newDate)
        } else {
            return "*******"
        }
    }
}

