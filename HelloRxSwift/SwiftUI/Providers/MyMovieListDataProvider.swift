//
//  MyMovieListDataProvider.swift
//  HelloRxSwift
//
//  Created by 高明阳 on 2021/2/25.
//

import SwiftUI

class MyMovieListDataProvider: ObservableObject {
    @Published
    var loading :Bool = false;
    
    @Published
    var error:MyError? ;
    
    @Published
    var movies:[MyMovie]?
    
    private var latestRequest:URLSessionDataTask?
    
    func searchMovies(_ input :String) -> Void {
        latestRequest?.cancel()
        
        loading = true
        DispatchQueue.global(qos: .background).async {[weak self] in
            let resultInput = self?.trimURLWhitSpace(urlString: input) ?? ""
            self?.latestRequest = QueryMovies(matching: resultInput, completion: { (result) in
                DispatchQueue.main.async {
                    self?.queryMoviesResultHandler(result: result)
                }
            })
        }
    }
    
    
    private func queryMoviesResultHandler(result:MyQueryMoviesResult){
        if(latestRequest == result.task){
            loading = false
        }
        if let task = result.task, task.state != .completed {
            return
        }
        movies = result.movies
        error  = result.error
        print(result.error ?? "")
        print("queryMoviesResultHandler =========")
        print(movies ?? "" )
        
    }
    
    private func trimURLWhitSpace(urlString:String )-> String {
        let resultStr = urlString.removeAllSapce
        return resultStr;
    }
}

extension String {
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}

