//
//  Requests.swift//

import Foundation
import Alamofire

class Requests {
    static func fetchResturantList(completion: @escaping (_ success:Bool,_ resturantList: [ResturantData]) -> Void) {
        Alamofire.request(Server.ResturantURL, method:.get, parameters: nil, encoding: JSONEncoding.default, headers:nil).responseJSON { response in
            switch response.result {
            case .success:
                debugPrint(response)
                if let data = response.data {
                    do {
                        let userData = Data(data)
                        let result = try JSONDecoder().decode([ResturantData].self, from: userData)
                        print("result: \(result)")
                        completion(true, result)
                    }
                    catch {
                        completion(false, [ResturantData]())
                    }
                }
            case .failure(let error):
                print(error)
                completion(false, [ResturantData]())
            }
        }
    }
    
}
