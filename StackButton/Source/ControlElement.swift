//
//  ControlElement.swift
//  StackButton
//
//  Created by xiaoyuan on 2021/7/30.
//

import UIKit

public protocol FeedbackGeneratable {

    typealias FeedbackType = UINotificationFeedbackGenerator.FeedbackType

    func generateSelectionFeedback()
    func generateImpactFeedback()
    func generateNotificationFeedback(type: FeedbackType)
}

public extension FeedbackGeneratable {

    func generateSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    func generateImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func generateNotificationFeedback(type: FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

open class ControlElement: UIControl, FeedbackGeneratable {

    private(set) var currentState: State = .normal

    open override var isHighlighted: Bool {
        didSet {
            let newState: State = isHighlighted ? .highlighted : (isSelected ? .selected : .normal)
            setState(newState)
        }
    }

    open override var isEnabled: Bool {
        didSet {
            let newState: State = isEnabled ? (isSelected ? .selected : .normal) : .disabled
            setState(newState)
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            let newState: State = isSelected ? .selected : .normal
            setState(newState)
        }
    }

    open var isFeedbackEnabled: Bool = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupFeedback()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFeedback()
    }

    final public func setState(_ newState: State) {
        currentState = newState
        stateDidChange()
    }

    open func stateDidChange() {
        
    }

    open func valueDidChange() {
        sendActions(for: .valueChanged)
    }

    private func setupFeedback() {
        addTarget(self, action: #selector(handleFeedbackIfNeeded), for: [.touchDown, .touchDragEnter])
    }

    @objc
    private func handleFeedbackIfNeeded() {
        guard isFeedbackEnabled else { return }
        generateSelectionFeedback()
    }
}

extension UIControl.State: Hashable, CaseIterable {
    public static var allCases: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    public var hashValue: Int {
        return Int(rawValue)
    }
}
