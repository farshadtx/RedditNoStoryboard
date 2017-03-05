import Quick
import Nimble

@testable import Reddit_NoStoryboard

class FeedCellSpec: QuickSpec {
    override func spec() {
        describe("FeedCellSpec") {
            var subject: FeedCell!
            
            beforeEach {
                subject = FeedCell()
            }
            
            describe("#init") {
                it("calls configure view") {
                    expect(subject.backgroundColor).to(equal(UIColor.darkGray))
                    
                    expect(subject.lblTitle.lineBreakMode).to(equal(NSLineBreakMode.byWordWrapping))
                    expect(subject.lblTitle.numberOfLines).to(equal(0))
                    expect(subject.lblTitle.textColor).to(equal(UIColor.white))
                    
                    expect(subject.lblTime.font).to(equal(UIFont.systemFont(ofSize: 10)))
                    expect(subject.lblTime.textColor).to(equal(UIColor.lightGray))
                }
                
                it("calls set constraints") {
                    subject.layoutIfNeeded()
                    
                    expect(subject.lblTitle.bounds.width).to(equal(320 - 24 - 50))
                    expect(subject.lblTime.bounds.height).to(beCloseTo(10.0))
                    expect(subject.imgThumb.bounds.height).to(equal(50))
                    expect(subject.imgThumb.bounds.width).to(equal(50))
                }
            }
            
            describe("#configure") {
                let feed = RedditFeed(title: "test-title", thumbnail_url: nil, comments_url: "some-url", time: 1488560746, after: nil)
                beforeEach {
                    subject.configure(feed: feed)
                }
                
                it("sets the labels correctly") {
                    expect(subject.lblTitle.text).to(equal("test-title"))
                    expect(subject.lblTime.text).to(equal("Mar 3, 2017, 9:05 AM"))
                    expect(subject.imgThumb.image).toNot(beNil())
                }
            }
        }
    }
}
