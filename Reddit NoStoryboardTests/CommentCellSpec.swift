import Quick
import Nimble

@testable import Reddit_NoStoryboard

class CommentCellSpec: QuickSpec {
    override func spec() {
        describe("CommentCell") {
            var subject: CommentCell!
            
            beforeEach {
                subject = CommentCell()
            }
            
            describe("#init") {
                it("calls configure view") {
                    expect(subject.backgroundColor).to(equal(UIColor.darkGray))
                    
                    expect(subject.lblComment.lineBreakMode).to(equal(NSLineBreakMode.byWordWrapping))
                    expect(subject.lblComment.numberOfLines).to(equal(0))
                    expect(subject.lblComment.textColor).to(equal(UIColor.white))
                    
                    expect(subject.lblTime.font).to(equal(UIFont.systemFont(ofSize: 10)))
                    expect(subject.lblTime.textColor).to(equal(UIColor.lightGray))
                }
                
                it("calls set constraints") {
                    subject.layoutIfNeeded()
                    
                    expect(subject.lblComment.bounds.width).to(equal(320 - 16))
                    expect(subject.lblTime.bounds.height).to(beCloseTo(10.0))
                }
            }
            
            describe("#configure") {
                let comment = RedditComment(comment: "test-comment", time: 1488560746)
                beforeEach {
                    subject.configure(comment: comment)
                }
                
                it("sets the labels correctly") {
                    expect(subject.lblComment.text).to(equal("test-comment"))
                    expect(subject.lblTime.text).to(equal("Mar 3, 2017, 9:05 AM"))
                }
            }
        }
    }
}
