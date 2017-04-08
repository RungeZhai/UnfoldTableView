# UnfoldTableView
An unfolding animation when loading a UITableView

### Demo
<img src="https://cloud.githubusercontent.com/assets/3366713/10016989/8475f8b2-615d-11e5-8ada-216446237068.gif" width=316>


### Usage
The unfolding effect is implemented in the cell. Just register `UnfoldTableViewCell` (or its subclass) as the cell class of your tableview and the animation is automatically performed when loading the tableview for the very first time. A `semaphore` is used so that the unfolding animation is performed one after another. Please refer to the implementation of the method `performUnfoldAnimation` if you are interested in the details.
