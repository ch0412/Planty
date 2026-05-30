import UIKit

class DiaryCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var diaryImageView: UIImageView!
    
    // imageView 높이 constraint (IBOutlet으로 연결)
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
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
