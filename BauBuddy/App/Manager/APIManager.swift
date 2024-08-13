//
//  APIManager.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import Alamofire

class APIManager {
    static let shared = APIManager()
    private var accessToken: String?

    func login(completion: @escaping (Bool) -> Void) {
        let url = "https://api.baubuddy.de/index.php/login"
        let headers: HTTPHeaders = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        let parameters: [String: String] = [
            "username": "365",
            "password": "1"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: OAuthResponse.self) { response in
            switch response.result {
            case .success(let oauthResponse):
                self.accessToken = oauthResponse.oauth.access_token
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func fetchTasks(completion: @escaping () -> Void) {
        guard let token = accessToken else { return }

        let url = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .get, headers: headers).responseDecodable(of: [Task].self) { response in
            switch response.result {
            case .success(let tasks):
                Globals.shared.tasks = tasks
                completion()
            case .failure:
                completion()
            }
        }
    }
    
    func initializeAppData(completion: @escaping (Bool) -> Void) {
        APIManager.shared.login { success in
            if success {
                APIManager.shared.fetchTasks {
                    print("Tasks were successfully pulled!")
                    completion(true)
                }
            } else {
                print("Login failed.")
                completion(false)
            }
        }
    }
}
