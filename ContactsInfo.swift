//
//  ContactInfo.swift
//  Pocketmon
//
//  Created by ios_starter on 4/17/25.
//

import UIKit
import SnapKit
import Alamofire

class ContactCell: UITableViewCell{
    let photo = UIImageView()//소괄호는 생성자
    let name =  UILabel()
    let number = UILabel()
    let add = UIButton()
    
    static let identifier = "ContactCell"
    
    //테이블뷰 초기화는 style과 reeuseidentifier 기반으로 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {// 셀 내부의 UI 설정하는 함수
        
        // 갑자기 왠 contentView?
        //UITableViewCell안에는 기본으로 콘텐츠 전용 뷰로 ContentView가 들어있음
        //이는 셀 안의 실제 콘텐츠를 담는 공간으로 표시될 UI요소들은 이 안에 추가해야 제대로 동작함
        //셀에 직접적으로 추가하면 X
        contentView.addSubview(photo)
        photo.layer.cornerRadius = 35
        photo.clipsToBounds = true
        photo.layer.borderWidth = 1
        photo.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(name)
        name.font = UIFont.systemFont(ofSize: 16)
        name.text = "Who?"
        name.textColor = .black
        
        contentView.addSubview(number)
        number.font = UIFont.systemFont(ofSize: 16)
        number.text = "010-xxxx-xxxx"
        number.textColor = .darkGray
        
//        add.setTitle("추가", for: .normal)
//        add.setTitleColor(.black, for: .normal)
//        add.layer.borderColor = UIColor.black.cgColor
//        add.layer.borderWidth = 0.8
//        add.backgroundColor = .clear

//        contentView.addSubview(add)
        
        photo.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        name.snp.makeConstraints {
            $0.left.equalTo(photo.snp.right).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        number.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.centerY.equalTo(name.snp.centerY)
        }
        
    }
    
}


