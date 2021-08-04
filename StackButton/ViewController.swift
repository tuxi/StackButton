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
        
        let centerBtn = StackButton(frame: CGRect(x: 100, y: 200, width: 120, height: 60))
        centerBtn.setTitle("点我", for: .normal)
        view.addSubview(centerBtn)
        
        // 打开注释，测试使用自动布局
        centerBtn.translatesAutoresizingMaskIntoConstraints = false
        centerBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        centerBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        centerBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        centerBtn.backgroundColor = UIColor.black
        centerBtn.setTitleColor(.white, for: .normal)
        centerBtn.setImage(UIImage(named: "map_filter_selected"), for: .normal)
        centerBtn.titleImageSpacing = 8
        centerBtn.imagePosition = .front
        centerBtn.titleLabel.numberOfLines = 1
        
        centerBtn.contentHorizontalAlignment = .left
        
        centerBtn.addTarget(self, action: #selector(tapCenterBtn), for: .touchUpInside)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self, weak centerBtn] timer in
            self?.tapCenterBtn(sender: centerBtn!)
        }
    }
    
    @objc private func tapCenterBtn(sender: StackButton) {
        sender.titleLabel.numberOfLines = 1
        switch sender.contentHorizontalAlignment {
        case .left:
            sender.contentHorizontalAlignment = .right
            sender.setTitle("右对齐", for: .normal)
        case .right:
            sender.contentHorizontalAlignment = .center
            sender.setTitle("中心对齐，测试文字长度嘟嘟嘟嘟对独独对嘟嘟嘟嘟嘟嘟对嘟嘟", for: .normal)
            sender.titleLabel.numberOfLines = 0
        case .center:
            sender.contentHorizontalAlignment = .left
            sender.setTitle("左对齐，4456546546546465465464556qweqweqweqweqeqeqweqweqeqeqw", for: .normal)
            sender.titleLabel.numberOfLines = 1
        default:
            break
        }
        
//        switch sender.contentVerticalAlignment {
//        case .top:
//            sender.contentVerticalAlignment = .bottom
//            sender.setTitle("下对齐", for: .normal)
//        case .bottom:
//            sender.contentVerticalAlignment = .center
//            sender.setTitle("中心对齐，测试文字长度嘟嘟嘟嘟对独独对嘟嘟嘟嘟嘟嘟对嘟嘟", for: .normal)
//            sender.titleLabel.numberOfLines = 0
//        case .center:
//            sender.contentVerticalAlignment = .top
//            sender.setTitle("上对齐，4456546546546465465464556qweqweqweqweqeqeqweqweqeqeqw", for: .normal)
//            sender.titleLabel.numberOfLines = 1
//        default:
//            break
//        }
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
        btn.titleImageSpacing = 6
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
