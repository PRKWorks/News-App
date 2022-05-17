//
//  newsAPI.swift
//  newsApp
//
//  Created by Ram Kumar on 18/03/22.
//

import Foundation
import UIKit

class newsAPI {
    struct const {
        static var apiKey = "649905fdce594c0a8f76cfbdac65cf3e"
        static let baseURL = "https://newsapi.org/v2/top-headlines?"
        static var url = URL(string : "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(apiKey)")
        static var newsDetails : [News] = []
        static var article : [Article] = []
        static var selectedURL = URL(string: "")
    }
    
    // MARK: - getnewsInfo
    class func getnewsInfo(category : String, completion: @escaping(Bool,Error?)->Void) {
        var selectedURL = URL(string : "https://newsapi.org/v2/top-headlines?country=in&category=\(category)&apiKey=\(newsAPI.const.apiKey)")
        var newsData = newsAPI.taskForGETRequest(url: selectedURL!, responseType: News.self)
        {
            response, error in
        // check for error
            guard let response = response else
            {
                completion(false,error)
                print("error ::",error!)
                return
            }
//            const.newsDetails = response
            const.article = response.articles
//            const.article.append(response)
            completion(true,nil)
        }
    }

    // MARK: - taskForGETRequest
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion:  @escaping(ResponseType?,Error?)->Void) -> URLSessionDataTask
    {
        // Create a URLRequest Object
        let urlreq = URLRequest(url: url)
        // Create a data task
        let task = URLSession.shared.dataTask(with: urlreq) { data, response, error in
            // check for error
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    completion(nil, error)
                }
                return
            }
            do
            {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async
                {
                    completion(responseObject, nil)
                }
            }
            catch
            {
                print(error)
                completion(nil,error)
            }
        }
        task.resume()
        
        return task
    
    }
}
