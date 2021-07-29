//
//  StackButton.swift
//  StackButton
//
//  Created by xiaoyuan on 2021/7/30.
//

import UIKit

/// 借鉴`UIStackView`的布局思想，实现一个自动布局的`StackButton`
/// 使用方式与`UIButton`一致，内容默认的排列方向为横向
open class StackButton: ControlElement {
    private enum PropertyKey: String, CaseIterable {
        case backgroundColor, title, attributedTitle, titleColor, image
    }
    
    /// 图片的位置
    public enum ImagePosition {
        /// 前面，
        /// 当`axis==horizontal`子控件横向排列时，`front=left`
        /// 当`axis==vertical`子控件垂直排列时，`front=top`
        case front
        /// 后面
        /// 当`axis==horizontal`子控件横向排列时，`back=right`
        /// 当`axis==vertical`子控件垂直排列时，`front=bottom`
        case back
    }
    
    // MARK: - Properties
    
    /// 子控件排列的轴心，默认为横向排列
    open var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    private var animator: UIViewPropertyAnimator?
    private var properties: [ElementState:[PropertyKey:Any]] = [
        ElementState.normal: [:],
        ElementState.highlighted: [:],
        ElementState.disabled: [:],
        ElementState.selected: [:]
    ]
    
    /// 子控件之间的间距
    open var titleImageSpacing: CGFloat = 0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    /// `image`的位置，默认在`title`的前面
    open var imagePosition: ImagePosition = .front {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    open var adjustImageWhenHighlighted: Bool = false
    
    /// 内容边距
    open var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsUpdateConstraints()
            
            contentViewConstraints.forEach {
                switch $0.firstAttribute {
                case .top:
                    $0.constant = contentEdgeInsets.top
                case .bottom:
                    $0.constant = contentEdgeInsets.bottom
                case .left, .leading:
                    $0.constant = contentEdgeInsets.left
                case .right, .trailing:
                    $0.constant = contentEdgeInsets.right
                default:
                    assertionFailure()
                }
            }
        }
    }
    
    open override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet {
            updateContentViewConstraints()
        }
    }
    
    open override var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        didSet {
            updateContentViewConstraints()
        }
    }
    
    // MARK: - Views
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .center
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var subviewsConstraints = [NSLayoutConstraint]()
    private var contentViewConstraints = [NSLayoutConstraint]()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        controlDidLoad()
    }
    
    /// 初始化方法，默认排列方向为横向
    public convenience init(axis: NSLayoutConstraint.Axis = .horizontal) {
        self.init(frame: .zero)
        self.axis = axis
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        controlDidLoad()
    }
    
    private func controlDidLoad() {
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        setTitleColor(.black, for: .normal)
        setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        /// 抵抗外部设置Button最大宽度时，即使不满足条件也被拉伸的问题
        /// `button.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true`
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        updateContentViewConstraints()
    }
    
    open override func updateConstraints() {
        updateSubviewsConstraints()
        super.updateConstraints()
    }
    
    /// 给 `label` 和 `image` 更新约束
    private func updateSubviewsConstraints() {
        removeConstraints(subviewsConstraints)
        subviewsConstraints.removeAll()
        
        let metrics: [String : Any] = ["spacing": titleImageSpacing]
        
        var frontView: UIView
        var backView: UIView
        switch imagePosition {
        case .front:
            frontView = imageView
            backView = titleLabel
            titleLabel.textAlignment = .left
        case .back:
            frontView = titleLabel
            backView = imageView
            titleLabel.textAlignment = .right
        }
        
        let views: [String: UIView] = ["frontView": frontView, "backView": backView]
        
        var format = "|[frontView]-(spacing)-[backView]|"
        
        switch axis {
        case .horizontal:
            format = "H:" + format
            [frontView, backView].forEach {
                var temp = [NSLayoutConstraint]()
                temp.append($0.topAnchor.constraint(equalTo: contentView.topAnchor))
                temp.append($0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
                if $0 is UIImageView {
                    // 设置label或者image其中一个控件的约束优先级低
                    // 让imageView相对contentView的上下约束优先级低一些, 以适应label.text文本改变时能撑起Button
                    // 并且在label.height < imageView.height时，imageView可以撑起Button的宽度
                    temp.forEach { $0.priority = .defaultLow }
                }
                subviewsConstraints.append(contentsOf: temp)
                subviewsConstraints.append($0.centerYAnchor.constraint(equalTo: centerYAnchor))
            }
        case .vertical:
            format = "V:" + format
            [frontView, backView].forEach {
                var temp = [NSLayoutConstraint]()
                temp.append($0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
                temp.append($0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
                if $0 is UIImageView {
                    // 设置label或者image其中一个控件的约束优先级低
                    // 让imageView相对contentView的左右约束优先级低一些, 以适应label.text文本改变时能撑起Button
                    // 并且在label.width < imageView.width时，imageView可以撑起Button的宽度
                    temp.forEach { $0.priority = .defaultLow }
                }
                subviewsConstraints.append(contentsOf: temp)
                subviewsConstraints.append($0.centerXAnchor.constraint(equalTo: centerXAnchor))
            }
        @unknown default:
            break
        }
        
        
        subviewsConstraints.append(contentsOf: ([format].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: metrics, views: views)
        }))
        
        addConstraints(subviewsConstraints)
    }
    
    /// 给`contentView`添加约束
    private func updateContentViewConstraints() {
        removeConstraints(contentViewConstraints)
        contentViewConstraints.removeAll()
        
        let insets = self.contentEdgeInsets
        let metrics: [String : Any] = ["left" : insets.left, "right" : insets.right, "top" : insets.top, "bottom" : insets.bottom, "spacing": titleImageSpacing]
        
        var contentViewHFormat = "H:|-(left)-[view]-(right)-|"
        var contentViewVFormat = "V:|-(top)-[view]-(bottom)-|"
        
        switch contentHorizontalAlignment {
        case .left, .leading:
            contentViewHFormat = "H:|-(left)-[view]-(<=right)-|"
        case .right, .trailing:
            contentViewHFormat = "H:|-(>=left)-[view]-(right)-|"
        case .center, .fill:
            contentViewHFormat = "H:|-(left)-[view]-(right)-|"
        @unknown default:
            break
        }
        
        switch contentVerticalAlignment {
        case .top:
            contentViewVFormat = "V:|-(top)-[view]-(<=bottom)-|"
        case .bottom:
            contentViewVFormat = "V:|-(>=top)-[view]-(bottom)-|"
        case .center, .fill:
            contentViewVFormat = "V:|-(top)-[view]-(bottom)-|"
        @unknown default:
            break
        }
        
        contentViewConstraints.append(contentsOf: ([contentViewHFormat, contentViewVFormat].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: metrics, views: ["view": contentView])
        }))
        
        addConstraints(contentViewConstraints)
    }
    
    // MARK: - State Methods
    
    open override func stateDidChange() {
        super.stateDidChange()
        updateViewProperties()
    }
    
    open func setTitle(_ title: String?, for state: ElementState) {
        defer { updateViewProperties() }
        properties[state]?[.title] = title
    }
    
    open func setAttributedTitle(_ attributedTitle: NSAttributedString?, for state: ElementState) {
        defer { updateViewProperties() }
        properties[state]?[.attributedTitle] = attributedTitle
    }
    
    open func setTitleColor(_ titleColor: UIColor?, for state: ElementState) {
        defer { updateViewProperties() }
        properties[state]?[.titleColor] = titleColor
    }
    
    open func setBackgroundColor(_ backgroundColor: UIColor?, for state: ElementState) {
        defer { updateViewProperties() }
        properties[state]?[.backgroundColor] = backgroundColor
    }
    
    open func setImage(_ image: UIImage?, for state: ElementState) {
        defer { updateViewProperties() }
        properties[state]?[.image] = image
    }
    
    open func setPrimaryColor(to color: UIColor?) {
        defer { stateDidChange() }
        properties[.normal]?[.backgroundColor] = color
        let titleColor = (color?.isLight ?? true) ? UIColor.black : UIColor.white
        properties[.normal]?[.titleColor] = titleColor
        let accentColor = (color?.isLight ?? true) ? color?.darker() : color?.lighter()
        properties[.highlighted]?[.backgroundColor] = accentColor
        properties[.highlighted]?[.titleColor] = titleColor.withAlphaComponent(0.3)
        properties[.disabled]?[.backgroundColor] = color?.lighter(by: 5)
        properties[.disabled]?[.titleColor] = titleColor.withAlphaComponent(0.3)
        properties[.selected]?[.backgroundColor] = accentColor
        properties[.selected]?[.titleColor] = titleColor.withAlphaComponent(0.3)
    }
    
    private func updateViewProperties() {
        if let color = properties[currentState]?[.backgroundColor] as? UIColor {
            backgroundColor = color
        }
        if let color = properties[currentState]?[.titleColor] as? UIColor {
            titleLabel.textColor = color
            imageView.tintColor = color
        }
        if let title = properties[currentState]?[.title] as? String {
            titleLabel.text = title
            setNeedsLayout()
        }
        if let attributedTitle = properties[currentState]?[.attributedTitle] as? NSAttributedString {
            titleLabel.attributedText = attributedTitle
            setNeedsLayout()
        }
        if let image = properties[currentState]?[.image] as? UIImage {
            imageView.image = image
            setNeedsLayout()
        }
        imageView.alpha = adjustImageWhenHighlighted ? 0.3 : 1
    }
    
    // MARK: - Animations
    
    @objc
    private func touchDown() {
        animator?.stopAnimation(true)
        setState(.highlighted)
    }
    
    @objc
    private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: { [weak self] in
            guard let `self` = self else { return }
            self.setState(self.isSelected ? .selected : .normal)
        })
        animator?.startAnimation()
    }
}

private extension UIColor {
    func isDarker(than color: UIColor) -> Bool {
        return self.luminance < color.luminance
    }
    
    func isLighter(than color: UIColor) -> Bool {
        return !self.isDarker(than: color)
    }
    
    var luminance: CGFloat {
        
        let RGBA = self.RGBA
        
        func lumHelper(c: CGFloat) -> CGFloat {
            return (c < 0.03928) ? (c/12.92): pow((c+0.055)/1.055, 2.4)
        }
        
        return 0.2126 * lumHelper(c: RGBA[0]) + 0.7152 * lumHelper(c: RGBA[1]) + 0.0722 * lumHelper(c: RGBA[2])
    }
    
    var isDark: Bool {
        return self.luminance < 0.5
    }
    
    var isLight: Bool {
        return !self.isDark
    }
    
    var ciColor: CIColor {
        return CIColor(color: self)
    }
    var RGBA: [CGFloat] {
        return [ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha]
    }
    
    func darker(by percentage: CGFloat = 10.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage)) ?? .black
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else{
            return nil
        }
    }
    
    func lighter(by percentage: CGFloat = 10.0) -> UIColor {
        return self.adjust(by: abs(percentage)) ?? .white
    }
}
