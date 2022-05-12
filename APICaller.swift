//
//  APICaller.swift
//  NewsApp
//
//  Created by Darwin Gabin on 5/8/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constansts {
        static let topHeadlinesURL = URL(string:"https://newsapi.org/v2/top-headlines?country=us&apiKey=c33df024306540dea2e98fd21b9c763f")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constansts.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
        }
        else if let data = data {
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                
                print("Articles: \(result.articles.count)")
                completion(.success(result.articles))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [Article]
}
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let name: String
}
