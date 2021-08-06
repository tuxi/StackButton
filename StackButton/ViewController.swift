//
//  ViewController.swift
//  StackButton
//
//  Created by xiaoyuan on 2021/7/30.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let titleView = ContentView()
        titleView.backgroundColor = .red
        self.navigationItem.titleView = titleView
        
        let hButton = testHButton()
        let vButton = testVButton()

        testFrameButton()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self, weak hButton, weak vButton] timer in
            self?.tapButton(sender: hButton!)
            DispatchQueue.main.async {
                self?.tapButton(sender: vButton!)
            }
        }
    }
    
    /// 测试横向布局的StackButton
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
    
    /// 测试垂直布局的StackButton
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
        button.backgroundColor = UIColor.purple
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "map_filter_selected"), for: .normal)
        button.spacing = 8
        button.imagePosition = .front
        button.titleLabel.numberOfLines = 1
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }
    
    func testFrameButton() {
        let frameButton = StackButton(frame: CGRect(x: 100, y: 300, width: 80, height: 30))
        frameButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        frameButton.spacing = 10
        frameButton.setTitle("你好frame", for: .normal)
        frameButton.setTitle("传将为特斯拉提供刀片电池，9000亿比亚迪股价盘中又创新高", for: .highlighted)
        frameButton.backgroundColor = .red
        frameButton.setImage(UIImage(named: "login_problem_add_photo"), for: .normal)
        frameButton.setImage(UIImage(named: "map_filter_selected"), for: .highlighted)
        frameButton.sizeToFit()
        frameButton.addTarget(self, action: #selector(tapFrameButton), for: [.touchDown, .touchDragEnter])
        frameButton.addTarget(self, action: #selector(tapFrameButton), for: [.touchUpInside, .touchDragExit, .touchCancel])
        view.addSubview(frameButton)
    }
    
    @objc private func tapButton(sender: StackButton) {
        sender.titleLabel.numberOfLines = 1
        sender.setImage(UIImage(named: "map_filter_selected"), for: .normal)
        sender.imagePosition = .front
        
        switch sender.axis {
        case .horizontal:
            switch sender.contentHorizontalAlignment {
            case .left:
                sender.contentHorizontalAlignment = .right
                sender.setTitle("右对齐", for: .normal)
                sender.setImage(UIImage(named: "login_problem_add_photo"), for: .normal)
            case .right:
                sender.contentHorizontalAlignment = .center
                sender.setTitle("中心对齐，测试文字长度嘟嘟嘟嘟对独独对嘟嘟嘟嘟嘟嘟对嘟嘟", for: .normal)
                sender.titleLabel.numberOfLines = 0
                sender.imagePosition = .back
                sender.axis = .vertical
            case .center:
                sender.contentHorizontalAlignment = .left
                sender.setTitle("无图片，左对齐，4456546546546465465464556qweqweqweqweqeqeqweqweqeqeqw", for: .normal)
                sender.titleLabel.numberOfLines = 1
                sender.setImage(nil, for: .normal)
            default:
                break
            }
        case .vertical:
            sender.axis = .vertical
            switch sender.contentVerticalAlignment {
            case .top:
                sender.contentVerticalAlignment = .bottom
                sender.setTitle("底部对齐", for: .normal)
            case .bottom:
                sender.contentVerticalAlignment = .center
                sender.setTitle("中心对齐，测试文字长度嘟嘟嘟嘟对独独对嘟嘟嘟嘟嘟嘟对嘟嘟", for: .normal)
                sender.titleLabel.numberOfLines = 0
                sender.imagePosition = .back
                sender.setImage(UIImage(named: "login_problem_add_photo"), for: .normal)
            case .center:
                sender.contentVerticalAlignment = .top
                sender.setTitle("无图片，顶部对齐，4456546546546465465464556qweqweqweqweqeqeqweqweqeqeqw", for: .normal)
                sender.titleLabel.numberOfLines = 1
                sender.setImage(nil, for: .normal)
                sender.axis = .horizontal
            default:
                break
            }
        @unknown default:
            break
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func tapFrameButton(sender: StackButton) {
        sender.sizeToFit()
    }
}


public class ContentView: UIView {
    
    enum Action {
        case didTapRightBtn
        case didTapLeftBtn
        case didTapSearchBtn
    }
    
    public lazy var searchButton: UIButton = {
       let label = UIButton()
        label.backgroundColor = .white
        label.setTitle(" 搜索服务", for: .normal)
        label.setTitleColor(.white, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        label.contentHorizontalAlignment = .left
        label.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.setImage(UIImage(named: "icon_home_search"), for: .normal)
        return label
    }()
    public lazy var leftButton: StackButton = {
        let btn = StackButton(axis: .horizontal)
        btn.setTitle("北京", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel.font = UIFont.systemFont(ofSize: 16)
        btn.setImage(UIImage(named: "home_nav_arrow_while"), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.titleLabel.lineBreakMode = .byTruncatingTail
        btn.imagePosition = .back
        btn.spacing = 6
        return btn
    }()
    
    public lazy var rightButton: StackButton = {
        let btn = StackButton(axis: .vertical)
        btn.setTitle("网点", for: .normal)
        btn.setImage(UIImage(named: "home_nav_point"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel.font = UIFont.systemFont(ofSize: 12)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        btn.titleLabel.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
//    fileprivate let actionEmitter: PublishSubject<Action> = PublishSubject()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        self.clipsToBounds = false
        addSubview(searchButton)
        addSubview(leftButton)
        addSubview(rightButton)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        leftButton.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10.0).isActive = true
        
        rightButton.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 10).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        rightButton.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true

        backgroundColor = .clear
        backgroundColor = .clear
        
        rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    @objc private func rightBtnClick() {
//        actionEmitter.onNext(.didTapRightBtn)
    }
    
    @objc private func leftBtnClick() {
//        actionEmitter.onNext(.didTapLeftBtn)
    }
    
    @objc private func searchBtnClick() {
//        actionEmitter.onNext(.didTapSearchBtn)
    }
    
    // MARK: - Override Methods
    /// 适配：在iOS 11 中苹果改变了UINavigationBar的视图层级，titleView不是加到NavigationBar上，而是加到了UINavigationBarContentView上，
    public override var intrinsicContentSize: CGSize {
        // 让其填充到navigationItem.titleView
        return UIView.layoutFittingExpandedSize
    }
}
