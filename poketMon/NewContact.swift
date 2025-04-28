//
//  NewContact.swift
//  Pocketmon
//
//  Created by ios_starter on 4/17/25.
//

import UIKit
import SnapKit
import Alamofire

class newContactView: UIViewController {
    
    let profile = UIImageView()
    let randomButton = UIButton()
    
    let newName = UITextField()
    let newNumber = UITextField()
    var imageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        
        //Alamofire로 데이터를 받아오는 구간
        AF.request("https://pokeapi.co/api/v2/pokemon/444", method: .get).responseDecodable(of: PoketmonData.self) { response in
            switch response.result {
            case .success(let data):
                print("\(data.name)")
                print("\(data.height)cm")
                print("\(data.weight)g")
                print("\(data.sprites.frontDefault)")
                //받아온 데이터를 UI에 연결
                //DispatchQueue.main.async {}는 메인 스레드에서 실행할 작업을 정의하는 코드 블럭이며
                //네트워크 응답은 백그라운드에서 오니까 UI 갱신을 아래처럼 메인 큐로 보내줘야 함
//                DispatchQueue.main.async {
//                    self.profile.load(url: data.sprites.frontDefault)
//                    self.newName.text = data.name // newName이라는 UITextField에 포켓몬 이름->data.name을 표시해주는 코드
//                    self.newNumber.text = "\(data.height)cm / \(data.weight)g"// 포켓몬의 키, 몸무게를 문자열로 만들어 UITextField에 넣는 코드
//                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        //UIViewController에서 title 설정하면 자동으로 navigationItem.title으로 값이 들어감
        //음 VC의 제목을 설정하고 내부적으로 네비게이션 바 중앙에서 자동으로 보여줌
        navigationItem.title = "New Contact"
        
        //이건 버튼 같이 인터랙션이 있는 요소로 UIViewControlller가 자동으로 처리해주지 않기때문에
        //직접 지정위해 적어줘야 함
        //아래 들어가는 title, style, target, action은 부수적인 요소 아닌 기본 구조임
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done", //버튼에 표시될 텍스트
            style: .done, //버튼 스타일
            target: self,//self는 현재 VC
            action: #selector(doneTapped)// 버튼 클릭하면 호출될 메서드
        )
        
    }
    
    //요청사항: 포켓몬의 정보를 랜덤하게 불러오고 이미지를 profile창에 띄워줘
//    1. 1~898 사이의 랜덤 숫자를 뽑는다
//    2. 해당 숫자를 포켓몬 ID로 사용하여 API URL을 만든다
//    3. Alamofire를 사용해 API를 요청한다
//    4. 데이터를 받아오면 → 디코딩한다
//    5. 디코딩된 정보를 기반으로 UI 요소들을 갱신한다 (이름, 이미지, 키/몸무게)
//    6. 만약 실패하면 → 에러 메시지를 출력한다
    @objc func bringPoketmon() {
        let randomNumber = Int.random(in: 1...898)  // 898까지가 안정적
        let apiUrl = "https://pokeapi.co/api/v2/pokemon/\(randomNumber)"

        AF.request(apiUrl).responseDecodable(of: PoketmonData.self) { response in
            switch response.result {
            case .success(let data):
                let imageUrl = data.sprites.frontDefault
                print("이미지 URL: \(imageUrl)")
                
                DispatchQueue.main.async {
                    self.imageUrl = data.sprites.frontDefault
                    self.profile.load(url: data.sprites.frontDefault)
                }
            case .failure(let error):
                print("이미지 로드 실패: \(error)")
            }
        }
    }
//by 챗지피티
    
    @objc func doneTapped() {
        print("정상 작동")//하단 콘솔창에 뜨는 디버깅용
        saveNewData()
    }
    
    private func saveNewData() {
        
        let userName = newName.text ?? ""
        let userNumber = newNumber.text ?? ""
        let userImage = imageUrl?.absoluteString ?? ""
        let data = UserDefaults.standard.object(forKey: "saveContact") as? Data
        
        var contactList: [contact] = []
        if let data = data {
            let savedContactList = try? JSONDecoder().decode([contact].self, from: data)
            contactList = savedContactList ?? []
        } //유저디폴트에 있는 값을 가지고 오고
        let contact = contact(name: userName, num: userNumber, image: userImage)
        contactList.append(contact)
        
        let jsonData = try? JSONEncoder().encode(contactList)
                if let jsonData {
                    UserDefaults.standard.set(jsonData, forKey: "saveContact")
                }
        //컨택트 배열에 103번쨰 컨택트 변수를 append시키면
        
        
        print("저장 완료")
        
        navigationController?.popViewController(animated: true)
    }
    
    
    private func configureUI() {
        
        profile.layer.borderWidth = 1.0//???????
        profile.layer.borderColor = UIColor.black.cgColor
//        profile.layer.cornerRadius = pㅌrofile.frame.height/2 //가로세로 1:1 비율로? 원형 만듬?
        profile.layer.cornerRadius = 90
        profile.contentMode = .scaleAspectFill
        profile.clipsToBounds = true
        view.addSubview(profile)
        
        
        randomButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        randomButton.setTitleColor(.black, for: .normal)
        randomButton.sizeToFit()//들어가는 문구에 맞춰 버튼 사이즈가 유동적으로 변화함
        randomButton.addTarget(self, action: #selector(bringPoketmon), for: .touchUpInside)
        view.addSubview(randomButton)
        
        newName.borderStyle = .roundedRect
        newName.layer.borderColor = UIColor.darkGray.cgColor
        newName.layer.borderWidth = 1.0
        newName.backgroundColor = .white
        newName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newName)
        
        newNumber.borderStyle = .roundedRect
        newNumber.layer.borderColor = UIColor.darkGray.cgColor
        newNumber.layer.borderWidth = 1.0
        newNumber.backgroundColor = .white
        newNumber.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newNumber)
        
        
        //레이아웃 잡는 구간
        profile.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(180)
            $0.width.equalTo(180)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            //safe area 포함하여 네비게이션 바 아래서 20pt 아래 배치한다는 뜻
            //근데 직접 네비게이션 바를 사용하고 있다면 'navigationController?.navigationBar.frame.maxY'로도 쓴다(?)
        }
        
        randomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profile.snp.bottom).offset(10)
        }
        
        newName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randomButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(43)
        }
        
        newNumber.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalTo(newName.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(43)
        }
    }
}

struct PoketmonData: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    // 기존에 내가 알았던 대로 URL 하나로 받아올 수 없음. 왜냐
    // 제공된 sprites는 url이 아니고 "front_default": "https://~~" 이렇게
    // 안에 key, value를 갖고 있는 Json객체임
    let sprites: SpritesData
}

struct SpritesData: Codable {
    let frontDefault: URL
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
}

// 지금 Alamofire를 통해 API 요청을 보냈을때
// sprites.frontDefault는 String 형태의 이미지 url을 제공하고 있음
// extension UIImageView로 UIImageView라는 타입 전체에 새 기능을 부여하면 앞서 선언한 profile도 해당 기능을 가져다 쓸 수 있다~
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}


