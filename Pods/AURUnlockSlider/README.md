# AURUnlockSlider

![language](https://img.shields.io/badge/Language-%20Swift%20-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/AURCherryBlossomView.svg?style=flat)](http://cocoapods.org/pods/AURUnlockSlider)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/AURCherryBlossomView.svg?style=flat)](http://cocoapods.org/pods/AURUnlockSlider)

## Usage

### Import
```swift
import "AURUnlockSlider"
```

### Init View and add the subView

```swift
let unlockSlider = AURUnlockSlider(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width * 0.8, 70.0))

self.view.addSubview(unlockSlider)
```

### conform to the delegate 

```swift
unlockSlider.delegate = self

func unlockSliderDidUnlock(snapSwitch: AURUnlockSlider) {

}
```


### Custom the attributes
```swift
unlockSlider.sliderText = "Slide to Unlock"
unlockSlider.sliderTextColor = UIColor.whiteColor()
unlockSlider.sliderTextFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0)!
unlockSlider.sliderColor = UIColor.clearColor()
unlockSlider.sliderBackgroundColor = UIColor(red: 231/255, green: 232/255, blue: 226/255, alpha: 0.5)

```

## Installation

Available in [CocoaPods](https://cocoapods.org/?q=AUR)

```ruby
pod "AURUnlockSlider"
```

## License

AURUnlockSlider is available under the MIT license. See the LICENSE file for more info.
