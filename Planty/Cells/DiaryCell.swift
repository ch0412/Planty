import UIKit

class DiaryCell: UITableViewCell {
    
    // MARK: - UI Elements
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // 기본 숨김
        return imageView
    }()
    
    // imageView 높이 constraint (동적으로 변경)
    var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(separatorLine)
        cardView.addSubview(contentLabel)
        cardView.addSubview(diaryImageView)
        
        imageHeightConstraint = diaryImageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            // 카드뷰
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // 제목
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // 구분선
            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separatorLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // 내용
            contentLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // 사진
            diaryImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            diaryImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            diaryImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            diaryImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            imageHeightConstraint
        ])
    }
    
    // MARK: - Configure
    func configure(with diary: DiaryEntry) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd."
        let dateString = formatter.string(from: diary.date)
        
        titleLabel.text = "\(diary.title) - \(dateString)"
        contentLabel.text = diary.content
        
        // 사진 표시
        if let image = diary.photoImages.first {
            diaryImageView.image = image
            diaryImageView.isHidden = false
            imageHeightConstraint.constant = 150
        } else {
            diaryImageView.isHidden = true
            imageHeightConstraint.constant = 0
        }
    }
}
