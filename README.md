## ShelfView (iOS) ##

*iOS custom view to display books on shelf* `     ` **([Android version is available here](https://github.com/tdscientist/ShelfView))** 

<img src="iphone.png" width="340"> <img src="ipad.png" width="528">

Requirements
--------

* iOS 8.0+
* Swift 3


Installation
--------

`ShelfView` is available through [CocoaPods](https://cocoapods.org/). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ShelfView'
```


**Note**
--------
Because of book covers whose URLs are `http`, update your `info.plist` as follows:

* add `App Transport Security Settings` to the list
* add `Allow Arbitrary Loads` to the security settings added above; set it to `YES`.

<img src="note.png" width="550">

Example 
--------

```swift
import ShelfView

class ViewController: UIViewController, ShelfViewDelegate {

var shelfView:ShelfView!
var bookModel = [BookModel] ()

override func viewDidLoad() {

  super.viewDidLoad()

  shelfView = ShelfView(frame: CGRect(x: 0, y: 0, width: 375, height: 647))        
  bookModel.append(
    BookModel.init(bookCoverSource: "http://www.aidanf.net/images/learn-swift/cover-web.png", 
    bookId: "0", 
    bookTitle: "Learn Swift"))
  
  shelfView.loadData(bookModel: bookModel, 
    bookSource: ShelfView.BOOK_SOURCE_URL)       

  shelfView.delegate = self        
  self.view.addSubview(shelfView)
}

func onBookClicked(_ shelfView: ShelfView, position: Int, bookId: String, bookTitle: String) {
  print("I just clicked \(bookTitle) with bookId \(bookId) @ position \(position)")
}

}
```


**Updating ShelfView data**

```swift
bookModel.append(
  BookModel.init(bookCoverSource: "https://www.packtpub.com/sites/default/files/9781785288197.png", 
  bookId: "1", 
  bookTitle: "Learning iOS UI Development"))
shelfView.updateData(bookModel: self.bookModel)
```


**Resizing ShelfView**

```swift
shelfView.resize(width: 647, height: 370, bookModel: self.bookModel)
```


**Loading book covers from other sources**

* iPhone/iPad document directory

```swift
bookModel.append(
  BookModel.init(bookCoverSource: "bookCover.png", 
  bookId: "0", 
  bookTitle: "Learn Swift"))
  
shelfView.loadData(bookModel: bookModel, 
  bookSource: ShelfView.BOOK_SOURCE_DEVICE_DOCUMENTS)
``` 



* iPhone/iPad library directory

```swift
bookModel.append(
  BookModel.init(bookCoverSource: "bookCover.png", 
  bookId: "0", 
  bookTitle: "Learn Swift"))      
  
shelfView.loadData(bookModel: bookModel, 
  bookSource: ShelfView.BOOK_SOURCE_DEVICE_LIBRARY)
```

* iPhone/iPad cache directory

```swift
bookModel.append(
  BookModel.init(bookCoverSource: "bookCover.png", 
  bookId: "0", 
  bookTitle: "Learn Swift"))
  
shelfView.loadData(bookModel: bookModel, 
  bookSource: ShelfView.BOOK_SOURCE_DEVICE_CACHE)
``` 

* Directly from your project's source code

```swift
bookModel.append(
  BookModel.init(bookCoverSource: "bookCover.png", 
  bookId: "0", 
  bookTitle: "Learn Swift"))
  
shelfView.loadData(bookModel: bookModel, 
  bookSource: ShelfView.BOOK_SOURCE_RAW)
``` 


License
--------

`ShelfView` is available under the MIT license. See the LICENSE file for more info.

Author
--------

Adeyinka Adediji _(tdscientist@gmail.com)_


Contributions & Bug Reporting
--------

tdscientist@gmail.com 

Credits 
--------

* [Kingfisher](https://github.com/onevcat/Kingfisher)

