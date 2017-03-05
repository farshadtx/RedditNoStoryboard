import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    let lblComment = UILabel()
    let lblTime = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comment: RedditComment) {
        lblComment.text = comment.comment
        lblTime.text = DateFormatter.localizedString(from: Date(timeIntervalSince1970: comment.time), dateStyle: .medium, timeStyle: .short)
    }
    
    // Private Functions
    private func configureView() {
        contentView.addSubview(lblComment)
        contentView.addSubview(lblTime)
        
        backgroundColor = UIColor.darkGray
        
        lblComment.lineBreakMode = .byWordWrapping
        lblComment.numberOfLines = 0
        lblComment.textColor = UIColor.white
        
        lblTime.font = UIFont.systemFont(ofSize: 10)
        lblTime.textColor = UIColor.lightGray
    }
    
    private func setConstraints() {
        lblComment.translatesAutoresizingMaskIntoConstraints = false
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
            "title" : lblComment,
            "time" : lblTime,
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[time]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-[time(10)]-|", options: [], metrics: nil, views: viewsDict))
    }
}
