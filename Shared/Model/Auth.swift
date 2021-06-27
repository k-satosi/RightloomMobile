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
            print(error)
        }
    }

    func register(url: String, name: String, email: String, password: String, passwordConfirmation: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: url + "/api/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params:[String:Any] = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirmation
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        DispatchQueue.main.async {
                            completion(String(data: data, encoding: .utf8))
                        }
                    } else {
                        do {
                            let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                            // dump(res)
                            var message = ""
                            for (_, value) in res {
                                let messages = value as! [String]
                                message = messages[0]
                                break
                            }
                            DispatchQueue.main.async {
                                completion(message)
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    // TODO: show error
                }
            })
            task.resume()
        } catch {
            print(error)
        }
    }
}

