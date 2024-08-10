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

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let oauth = json["oauth"] as? [String: Any],
                   let token = oauth["access_token"] as? String {
                    self.accessToken = token
                    completion(true)
                } else {
                    completion(false)
                }
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

        AF.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]] {
                    Globals.shared.tasks = jsonArray.compactMap { Task(json: $0) }
                    completion()
                }
            case .failure:
                completion()
            }
        }
    }
    
    func initializeAppData(){
        login { success in
            if success {
                self.fetchTasks {
                    print("Globals data: \(Globals.shared.tasks)")
                }
            }
        }
    }
}
