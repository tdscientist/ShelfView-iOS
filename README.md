## ShelfView (iOS) ##

*iOS custom view to display books on shelf*

<img src="iphone.png" width="340"> <img src="ipad.png" width="528">



Requirements
--------

* iOS 8.0+
* Swift 3


Installation
--------

ShelfView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ShelfView'
```

Example 
--------

```
import ShelfView

class ViewController: UIViewController, ShelfViewDelegate {

var shelfView:ShelfView!
var bookModel = [BookModel] ()

override func viewDidLoad() {

super.viewDidLoad()

shelfView = ShelfView(frame: CGRect(x: 0, y: 0, width: 375, height: 647))        
bookModel.append(BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", bookId: "0", bookTitle: "Learn Swift"))          
shelfView.loadData(bookModel: bookModel, bookSource: ShelfView.BOOK_SOURCE_URL)       

shelfView.delegate = self        
self.view.addSubview(shelfView)

}

func onBookClicked(_ shelfView: ShelfView, position: Int, bookId: String, bookTitle: String) {
print("I just clicked \(bookTitle) with bookId \(bookId) @ position \(position)")
}


}
```


**Updating ShelfView data**
```
bookModel.append(BookModel.init(bookCoverSource: "https://www.packtpub.com/sites/default/files/9781785288197.png", bookId: "1", bookTitle: "Learning iOS UI Development"))
shelfView.updateData(bookModel: self.bookModel)
```


**Resizing ShelfView**
```
shelfView.resize(width: 647, height: 370, bookModel: self.bookModel)
```


**Loading book covers from other sources**

* iPhone/iPad document directory
```
bookModel.append(BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", bookId: "0", bookTitle: "Learn Swift"))          
shelfView.loadData(bookModel: bookModel, bookSource: ShelfView.BOOK_SOURCE_DEVICE_DOCUMENTS)
``` 



* iPhone/iPad library directory
```
bookModel.append(BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", bookId: "0", bookTitle: "Learn Swift"))          
shelfView.loadData(bookModel: bookModel, bookSource: ShelfView.BOOK_SOURCE_DEVICE_LIBRARY)
```



* iPhone/iPad cache directory
```
bookModel.append(BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", bookId: "0", bookTitle: "Learn Swift"))          
shelfView.loadData(bookModel: bookModel, bookSource: ShelfView.BOOK_SOURCE_DEVICE_CACHE)
``` 

* Directly from your project's source code
```
bookModel.append(BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", bookId: "0", bookTitle: "Learn Swift"))          
shelfView.loadData(bookModel: bookModel, bookSource: ShelfView.BOOK_SOURCE_RAW)
``` 

-----
To run the example project, clone the repo, and run `pod install` from the Example directory first.

License
--------

ShelfView is available under the MIT license. See the LICENSE file for more info.

Author
--------

Adeyinka Adediji _(tdscientist@gmail.com)_


Contributions & Bug Reporting
--------

tdscientist@gmail.com 



Credits 
--------

* [Kingfisher](https://github.com/onevcat/Kingfisher)

