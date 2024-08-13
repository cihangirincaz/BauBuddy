//
//  OAuth.swift
//  BauBuddy
//
//  Created by cihangirincaz on 13.08.2024.
//

struct OAuthResponse: Decodable {
    let oauth: OAuthToken
}

struct OAuthToken: Decodable {
    let access_token: String
}
