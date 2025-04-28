//
//  ViewController.swift
//  Pocketmon
//
//  Created by ios_starter on 4/17/25.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let add = UIButton()
    let contactTable = UITableView()
//    let randomNames = ["여정", "소정", "가영", "수현", "우정", "수정", "세진", "혜임"]
//    let profileimg =  ["딸기", "레몬", "망고", "바나나", "블루베리", "수박", "아보카도", "풋사과"]
    var contactList: [contact] = []
    
    
    //여기는 view가 초기에 로드될 때 실행되는 화면을 구성하는 초기 설정 코드
    //이 구간에서 데이터 초기화, 뷰 스타일링, 계약조건 설정, 네트워크 호출 등을 담당함
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(contactTable)
        contactTable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }

        contactTable.delegate = self
        contactTable.dataSource = self
        contactTable.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        
        view.addSubview(add)
        
        ///알고리즘 = 순서도
//        let nameList = randomNames.shuffled()
//
//        for index in 0..<randomNames.count {
//            /*let nameList = randomNames.randomElement() ?? "이름 없음"*/ /*=> nil일 경우 대체할 기본값으로 "이름 없음" -> nil 병합이라고 한다고 함*/
//        // 위의 방법은 이름이 중복으로 뜸
//
//            let randomMiddle = Int.random(in: 1000...9999)
//            let randomLast = Int.random(in: 1000...9999)
////            for name in nameList {
//            let phoneNumber = "010-\(randomMiddle)-\(randomLast)"
//            contactList.append((nameList[index], phoneNumber, nil))
////            }
//        }
        
//        // 기존 contactList 초기화 코드 이후에 넣기
//        if let name = UserDefaults.standard.string(forKey: "saveNewName"),
//           let number = UserDefaults.standard.string(forKey: "saveNewNumber"),
//           let imageURLString = UserDefaults.standard.string(forKey: "saveNewImage"),
//           let imageURL = URL(string: imageURLString) {
//            contactList.insert((name, number, imageURL), at: 0)
//        }

        navigationItem.title = "List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add", //버튼에 표시될 텍스트
            style: .done, //버튼 스타일
            target: self,//self는 현재 VC
            action: #selector(addTapped)// 버튼 클릭하면 호출될 메서드
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let data = UserDefaults.standard.object(forKey: "saveContact") as? Data
        if let data = data {
            let savedContactList = try? JSONDecoder().decode([contact].self, from: data)
            contactList = savedContactList ?? []
        }
        
        contactTable.reloadData()
        print(contactList)
    }

    @objc func addTapped() {
        let newContactVC = newContactView()
        navigationController?.pushViewController(newContactVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }

    // 위와 같이 데이터 노출을 위한 핵심 메서드이며
    // 셀 내용 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }

        let contact = contactList[indexPath.row]
        cell.name.text = contact.name
        cell.number.text = contact.num
        
        if let url = URL(string: contact.image) {
            cell.photo.load(url: url)
        }
//        else {
//            cell.photo.image = UIImage(named: profileimg[indexPath.row % profileimg.count])
//        }

        return cell
    }
}


extension ViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
