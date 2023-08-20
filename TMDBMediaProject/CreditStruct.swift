//
//  CreditMovie.swift
//  TMDBMediaProject
//
//  Created by 정경우 on 2023/08/18.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let info = try? JSONDecoder().decode(Info.self, from: jsonData)

import Foundation

// MARK: - Info
struct CreditStruct: Codable {
    let id: Int
    let cast, crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment, name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}
