//
//  Auth.swift
//  Rightloom
//

import Foundation

class AuthInfo: ObservableObject {
    @Published var token = ""
    
    func login(url: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: url) else { return }
        self.token = ""
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params:[String:Any] = [
            "email": email,
            "password": password,
            "device_name": "iPhone"
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let data = data {
                    DispatchQueue.main.sync {
                        self.token = String(data: data, encoding: .utf8)!
                    }
                } else {
                    // TODO: show error
                }
                DispatchQueue.main.async {
                    completion(!self.token.isEmpty)
                }
            })
            task.resume()
        } catch {
            print(error);
        }
    }
}

