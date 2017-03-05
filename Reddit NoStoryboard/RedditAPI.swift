import Foundation
import RxSwift
import SwiftyJSON

let networkReddit = DispatchQueue(label: "mobi.farshad.networkReddit")

class RedditAPI {
    class func fetchFeeds(after: String?) -> Observable<[RedditFeed]> {
        return Observable.create { observer in
            let performNetworkQuery : Observable<Data> = Observable.create { rxObservable in
                var url = "https://www.reddit.com/r/sports.json"
                if let after = after {
                    url.append("?after=\(after)")
                }
                
                let request = URLRequest(url: URL(string: url)!)
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    do {
                        guard error == nil else {
                            throw error!
                        }
                        
                        guard let data = data else {
                            throw RxError.unknown
                        }
                        
                        rxObservable.onNext(data)
                        rxObservable.onCompleted()
                    } catch(let error) {
                        rxObservable.onError(error)
                    }
                })
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            
            return performNetworkQuery
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: networkReddit))
                .map { (data: Data) -> ([RedditFeed]) in
                    guard JSON(data)["data"]["children"] != JSON.null else {
                        throw NSError(domain: "Bad data structure!", code: 1, userInfo: nil)
                    }
                    let json = JSON(data)["data"]
                    let after = json["after"].string
                    
                    var array: [RedditFeed] = []
                    for dictionary in json["children"].arrayValue {
                        let data = dictionary["data"]
                        let permalink = data["permalink"].stringValue
                        let comments_url = "https://www.reddit.com" + permalink.substring(to: permalink.index(before: permalink.endIndex)) + ".json"
                        array.append(RedditFeed(title: data["title"].stringValue, thumbnail_url: data["thumbnail"].string, comments_url: comments_url, time: data["created"].doubleValue, after: after))
                    }
                    
                    return array
                }
                .flatMap { Observable.from($0) }
                .toArray()
                .subscribe(observer)
        }
    }
    
    class func fetchComments(forFeed feed: RedditFeed) -> Observable<[RedditComment]> {
        return Observable.create { observer in
            let performNetworkQuery : Observable<Data> = Observable.create { rxObservable in
                let request = URLRequest(url: URL(string: feed.comments_url)!)
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    do {
                        guard error == nil else {
                            throw error!
                        }
                        
                        guard let data = data else {
                            throw RxError.unknown
                        }
                        
                        rxObservable.onNext(data)
                        rxObservable.onCompleted()
                    } catch(let error) {
                        rxObservable.onError(error)
                    }
                })
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            
            return performNetworkQuery
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: networkReddit))
                .map { (data: Data) -> ([RedditComment]) in
                    guard JSON(data)[1]["data"]["children"] != JSON.null else {
                        throw NSError(domain: "Bad data structure!", code: 1, userInfo: nil)
                    }
                    let json = JSON(data)[1]["data"]
                    
                    var array: [RedditComment] = []
                    for dictionary in json["children"].arrayValue {
                        let data = dictionary["data"]
                        array.append(RedditComment(comment: data["body"].stringValue, time: data["created"].doubleValue))
                    }
                    
                    return array
                }
                .flatMap { Observable.from($0) }
                .toArray()
                .subscribe(observer)
        }
    }
}
