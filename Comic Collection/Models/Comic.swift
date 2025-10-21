//
//  Comic.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import Foundation

struct Comic: Codable {
    //XKCD API JSON structure
    let num: Int //As there is no ID this can be used as ID for the comic
    let month: String
    let link: String
    let year: String
    let news: String
    let safeTitle: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
}
