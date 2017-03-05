import UIKit
import RxSwift
import RxCocoa

class FeedsViewController: UIViewController, UITableViewDelegate {
    private var tableView: UITableView!
    private var feedsSubject = BehaviorSubject<[RedditFeed]>(value: [])
    private var disposeBag = DisposeBag()
    private var isLoading = false
    
    private var feedsArray: [RedditFeed] {
        get {
            return try! self.feedsSubject.value()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        setDataSource()
        setDelegate()
        fetchFeeds()
        setLazyLoad()
    }
    
    // Private Functions
    private func configureView() {
        title = "Home"
        tableView = UITableView(frame: self.view.frame)
        tableView.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView()
        tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
            "table" : tableView,
            ] as [String : Any]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[table]-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: viewsDict))
    }
    
    private func setLazyLoad() {
        tableView.rx.contentOffset
            .filter { contentOffset in
                contentOffset.y + self.tableView.frame.size.height + 200 > self.tableView.contentSize.height && self.tableView.contentSize.height > 0
            }
            .skip(1)
            .subscribe { _ in
                if !self.isLoading {
                    let indexPath = self.tableView.indexPathsForVisibleRows?.last?.row
                    if let index = indexPath {
                        let lastElement = self.feedsArray[index]
                        self.fetchFeeds(after: lastElement.after)
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func fetchFeeds(after: String? = nil) {
        isLoading = true
        SwiftSpinner.show("Fetching Feeds ...")
        RedditAPI.fetchFeeds(after: after)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: networkReddit))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { redditFeeds in
                var currentResult = try! self.feedsSubject.value() as [RedditFeed]
                currentResult.append(contentsOf: redditFeeds)
                self.feedsSubject.asObserver().onNext(currentResult)
            }, onError: { error in
                SwiftSpinner.show("Fetching failed!")
            }, onCompleted: {
                self.isLoading = false
                SwiftSpinner.hide()
            }, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    private func setDataSource() {
        feedsSubject
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "FeedCell")) { (index, model, cell: FeedCell) in
                cell.configure(feed: model)
            }.addDisposableTo(disposeBag)
    }
    
    private func setDelegate() {
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.fetchComments(feed: self.feedsArray[indexPath.row])
            }).addDisposableTo(disposeBag)
    }
    
    private func fetchComments(feed: RedditFeed) {
        isLoading = true
        SwiftSpinner.show("Loading Comments ...")
        RedditAPI.fetchComments(forFeed: feed)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: networkReddit))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { redditComments in
                if redditComments.count > 0 {
                    let commentsViewController = CommentsViewController(comments: redditComments)
                    self.navigationController?.show(commentsViewController, sender: nil)
                    SwiftSpinner.hide()
                } else {
                    SwiftSpinner.show(duration: 2.0, title: "No Comments!")
                }
            }, onError: { error in
                SwiftSpinner.show("Fetching failed!")
            }, onCompleted: {
                self.isLoading = false
            }, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
}

