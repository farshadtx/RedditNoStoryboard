import UIKit
import Kingfisher

class FeedCell: UITableViewCell {
    let imgThumb = UIImageView()
    let lblTitle = UILabel()
    let lblTime = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(feed: RedditFeed) {
        lblTitle.text = feed.title
        imgThumb.kf.setImage(with: URL(string: feed.thumbnail_url ?? ""), placeholder: Image(named: "no_image"), options: nil, progressBlock: nil, completionHandler: nil)
        lblTime.text = DateFormatter.localizedString(from: Date(timeIntervalSince1970: feed.time), dateStyle: .medium, timeStyle: .short)
    }
    
    // Private Functions
    private func configureView() {
        contentView.addSubview(imgThumb)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblTime)
        
        backgroundColor = UIColor.darkGray
        
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.numberOfLines = 0
        lblTitle.textColor = UIColor.white
        
        lblTime.font = UIFont.systemFont(ofSize: 10)
        lblTime.textColor = UIColor.lightGray
    }
    
    private func setConstraints() {
        imgThumb.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
            "thumb" : imgThumb,
            "title" : lblTitle,
            "time" : lblTime,
        ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[thumb(50)]-(>=26)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-[thumb(50)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[time]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-[time(10)]-|", options: [], metrics: nil, views: viewsDict))
    }
}
