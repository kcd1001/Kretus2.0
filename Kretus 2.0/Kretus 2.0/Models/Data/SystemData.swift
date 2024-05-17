//
//  SystemData.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 2/23/24.
//


import Foundation
import SwiftData

@Model
final class SystemData {
    let name: String
    let nameFromUser: String
    let descriptionFromUser: String
    let imageName: String
    let viewColor: String

    var subType: String
    var speeds: [String]
    var systemColor: String

    var squareFt: Int
    var kits: [KitRelationship]

    init(name: String, nameFromUser: String, descriptionFromUser: String, imageName: String, viewColor: String, subType: String, speeds: [String], systemColor: String, squareFt: Int, kits: [KitRelationship]) {
        self.name = name
        self.nameFromUser = nameFromUser
        self.descriptionFromUser = descriptionFromUser
        self.imageName = imageName
        self.viewColor = viewColor
        self.subType = subType
        self.speeds = speeds
        self.systemColor = systemColor
        self.squareFt = squareFt
        self.kits = kits
    }
}


