//
//  NetWorking.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

fileprivate let URLHost = "http://www.omdbapi.com/"

// [dho] TODO move this
fileprivate let OMDBAPIKey = "39783349"

struct MyQueryMoviesResult {
    let input  : String
    var task   : URLSessionDataTask? = nil
    var movies : [MyMovie]? = nil
    var error  : MyError? = nil
    
}

@discardableResult
func QueryMovies(matching :String ,completion : @escaping (MyQueryMoviesResult) -> Void ) -> URLSessionDataTask? {
    var result = MyQueryMoviesResult(input: matching)
    
    guard let search = matching.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        result.error = .invalidSearch(input: matching)
        completion(result)
        return nil
    }
    
    guard !search.isEmpty else {
        result.movies = [];
        completion(result)
        
        return nil;
    }
    let resultSearchText =  search
    print("mylog resultSearchText.count:\(resultSearchText.count)")
    let requestParam  = "s=\(resultSearchText)&apikey=\(OMDBAPIKey)"
    let urlString     = "\(URLHost)?\(requestParam)"
    let url = URL(string: urlString)!
    print("mylog url:\(urlString)")
    var request  = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            if let urlError = error as? URLError {
                result.error = .networkError(error: urlError)
            }else {
                result.error = .general(error: error!)
            }
            completion(result)
            return
        }
        
        guard let data = data else {
            result.error = .omdb(message: "No data received!")
            completion(result)
            return
        }
        
        do {
            let responseData = try JSONDecoder().decode(OMDBAPIMovieSearchResult.self,from :data)
            result.movies = responseData.Search
            
            if let errorMessage  = responseData.Error {
                result.error = .omdb(message: errorMessage)
            }else if responseData.Response == .failed{
                result.error = .omdb(message: "Request returned an unsuccessful response")
            }
            
            completion(result)
            
        }catch let parseError as NSError {
            result.error = .decodingError(error: parseError)
            completion(result)
        }
    }
    
    result.task = task
    task.resume()
    
    return task;
}

struct MyFectchImageResult {
    var task:URLSessionDataTask? = nil
    var image:UIImage? = nil
    var error:MyError? = nil
}

@discardableResult
func FetchImage(from url:URL ,completion :@escaping (MyFectchImageResult) -> Void) -> URLSessionDataTask? {
    var result = MyFectchImageResult()
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            if let urlError = error as? URLError {
                result.error = .networkError(error: urlError)
            }else {
                result.error = .general(error: error!)
            }
            
            completion(result)
            return
        }
        
        guard let data = data ,data.count > 0 else {
            result.error = .general(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Could not retrieve image data"]))
            completion(result)
            return
        }
        
        if let image = UIImage(data: data)
        {
            result.image = image;
        }else {
            result.error = .general(error : NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid image data"]))
        }
        completion(result)
    }
        
    result.task = task
    
    task.resume()
    
    return task;
}

 
