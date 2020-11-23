# SafetyFirst

## Summery
the federal state of Bavaria Covid-19 traffic light. main goal is to keep the citizens updated on new and upcoming Coronavirus / Covid-19 Regulations.

This is a small test application that communicates with the `https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0` API
to receive the cases in seven days per 100.000 residents, based on the current location of the device.

The current version of the application hase one single View, where the UI can be changed.

### Technical overview
#### Architecture
The chosen architecture is MVC with UIKit and Storyboard. The views are seperated in `Scene`. Each `Scene` consists of at least one `UIViewController`, where the UI will be build, a `Storyboad` and a `Controller` where the logic is based.

#### Network layer
The network layer consists of a `NetworkManager` and works with `EndPoint`s. Each API call has its own `EndPoint` struct that contains all relevant information needed to create a `URLRequest`.

## Credits
Erwin Warkentin

## License
For private use only. Copyright by Erwin Warkentin