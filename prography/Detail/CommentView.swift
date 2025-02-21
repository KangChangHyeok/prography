//
//  CommentView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class CommentView: UIView {
    
    private let commentLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Comment"
        $0.textColor = .black
        $0.font = .pretendard(size: 16, weight: .bold)
        $0.textAlignment = .left
    }
    
    lazy var commentTextView = UITextView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "후기를 작성해주세요."
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .placeholderText
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.main.cgColor
        $0.contentInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        $0.textContainerInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        $0.delegate = self
    }
    
    private var dateLabel = UILabel().configure {
        $0.font = .pretendard(size: 11, weight: .regular)
        $0.isHidden = true
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(commentLabel)
        
        let commentLabelLayoutConstraints: [NSLayoutConstraint] = [
            commentLabel.topAnchor.constraint(equalTo: self.topAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            commentLabel.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        NSLayoutConstraint.activate(commentLabelLayoutConstraints)
        
        self.addSubview(commentTextView)
        
        let commentTextViewLayoutConstraints: [NSLayoutConstraint] = [
            commentTextView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 8),
            commentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            commentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            commentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            commentTextView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(commentTextViewLayoutConstraints)
        
        self.addSubview(dateLabel)
        
        let dateLabelLayoutConstraints: [NSLayoutConstraint] = [
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            dateLabel.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: -32)
        ]
        
        NSLayoutConstraint.activate(dateLabelLayoutConstraints)
    }
    
    func bind(_ comment: String?, date: Date?) {
        commentTextView.text = comment
        
        commentTextView.layer.borderWidth = 0
        commentTextView.backgroundColor = .init(hex: "EDBAC5").withAlphaComponent(0.2)
        commentTextView.textColor = .black
        commentTextView.isEditable = false
        
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
            
        dateLabel.isHidden = false
        dateLabel.text = formatter.string(from: date!)
    }
}

extension CommentView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
                textView.textColor = .label
                textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "후기를 작성해주세요."
                textView.textColor = .placeholderText
            }
        }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.textContainer.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            guard estimatedSize.height >= 80 else { return }
            guard constraint.firstAttribute == .height else { return }
            constraint.constant = estimatedSize.height
        }
    }
}
