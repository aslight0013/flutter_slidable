## 0.4.3
### Fixed
* https://github.com/letsar/flutter_slidable/issues/23 (Issue with Drawer delegate when different action count).

## 0.4.2
### Fixed
* https://github.com/letsar/flutter_slidable/issues/22 and https://github.com/letsar/flutter_slidable/issues/24 (Issue with controller).

## 0.4.1
### Added
* The `SlidableController` class.
* The `controller` argument on `Slidable` constructors to enable keeping only one `Slidable` open.

## 0.4.0
### Added
* The `SlidableRenderingMode` enum.
* The `SlideActionType` enum.
* The `SlideToDismissDelegate` classes.

### Modified
* Added a renderingMode parameter in the `SlideActionBuilder` signature.

## 0.3.2
### Added
* The `enabled` argument on `Slidable` constructors to enable or disable the slide effect (enabled by default). 

## 0.3.1
### Fixed
* https://github.com/letsar/flutter_slidable/issues/11 (slide action not rebuild after controller dismissed).

## 0.3.0
### Added
* The `closeOnTap` argument on slide actions to close when a action has been tapped.
* The `closeOnScroll` argument on `Slidable` to close when the nearest `Scrollable` starts to scroll.
* The static `Slidable.of` function.

### Changed
* The `dragExtent` field in `SlidableDelegateContext` has been changed to `dragSign`. 

## 0.2.0
### Added
* `Slidable.builder` constructor.
* Vertical sliding.

## Changed
* The slide actions are now hosted in a `SlideActionDelegate` instead of `List<Widget>` inside the `Slidable` widget.
* The `leftActions` have been renamed to `actions`.
* The `rightActions` have been renamed to `secondaryActions`.

## 0.1.0
* Initial Open Source release.
