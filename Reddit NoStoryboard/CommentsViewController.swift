import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController, UITableViewDelegate {
    var comments: [RedditComment]!
    
    private var tableView: UITableView!
    private var disposeBag = DisposeBag()
    
    init(comments: [RedditComment]) {
        self.comments = comments
        
        super.init(nibName: nil, bundle: nil)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()
    }
    
    // Private Functions
    private func configureView() {
        title = "Comments"
        tableView = UITableView(frame: self.view.frame)
        tableView.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = UIView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
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
    
    private func setDataSource() {
        Observable.of(comments)
            .bindTo(tableView.rx.items(cellIdentifier: "CommentCell")) { (index, model, cell: CommentCell) in
                cell.configure(comment: model)
            }.addDisposableTo(disposeBag)
    }
}
