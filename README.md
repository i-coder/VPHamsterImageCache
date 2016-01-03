# VPHamsterImageCache
The easiest way to cache you images. 

## Usage
```swift
        VPHamsterImageCache.sharedCache.getImageForURLString(imageURLString) { (image, url) -> () in
            cell.imageView.image = image
        }
```
