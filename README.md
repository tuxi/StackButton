# StackButton

借鉴`UIStackView`的布局思想，实现一个自动布局的`StackButton`
使用方式与`UIButton`一致，内容默认的排列方向为横向

### 示例

测试横向布局的StackButton
```swift
func testHButton() -> StackButton {
    let hButton = StackButton()
    hButton.setTitle("点我", for: .normal)
    view.addSubview(hButton)
    
    //        hButton.frame = (frame: CGRect(x: 100, y: 200, width: 120, height: 60))
    // 打开注释，测试使用自动布局
    hButton.translatesAutoresizingMaskIntoConstraints = false
    hButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    hButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    hButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50).isActive = true
    
    hButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    hButton.backgroundColor = UIColor.orange
    hButton.setTitleColor(.white, for: .normal)
    hButton.setImage(UIImage(named: "map_filter_selected"), for: .normal)
    hButton.spacing = 8
    hButton.imagePosition = .front
    hButton.titleLabel.numberOfLines = 1
    
    hButton.contentHorizontalAlignment = .left
    
    hButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    return hButton
}
```

测试垂直布局的StackButton
```swift
func testVButton() -> StackButton {
    let button = StackButton(axis: .vertical)
    button.setTitle("点我", for: .normal)
    view.addSubview(button)
    
    // 打开注释，测试使用自动布局
    button.translatesAutoresizingMaskIntoConstraints = false
    button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    button.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30).isActive = true
    
    button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    button.backgroundColor = UIColor.black
    button.setTitleColor(.white, for: .normal)
    button.setImage(UIImage(named: "map_filter_selected"), for: .normal)
    button.spacing = 8
    button.imagePosition = .front
    button.titleLabel.numberOfLines = 1
    button.contentHorizontalAlignment = .left
    button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    return button
}

```
