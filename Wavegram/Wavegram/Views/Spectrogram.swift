//
//  Spectrogram.swift
//  Spectrogram
//
//  Created by 김제필 on 7/18/22.
//

import Foundation
import Accelerate
import UIKit



// MARK: CALayer내에 스펙트로그램을 표시함.
// CALayer는 애니메이션이 적용된 이미지 기반 콘텐츠를 표시하는 데 사용됨.
// 관련 문서: https://developer.apple.com/documentation/quartzcore/calayer
public class Spectrogram: CALayer {

    // 생성자.
    // override init(): 상속받은 생성자를 호출하는 생성자.
    override init() {
        super.init()

        // contentsGravity: 레이어 내 컨텐츠의 배율 결정
        // 컨텐츠의 실제 사이즈가 (w, h) 라면 화면에 표시되는 사이즈는 (w / contentsScale, h / contentsScale)
        // .resize: 컨텐츠가 전체 레이어 크기에 맞게 리사이즈되도록 지정하는 옵션
        contentsGravity = .resize
    }

    // required: 이 생성자가 반드시 구현되어야 한다는 제약조건
    // NSCoder: NextStep Coder. 과거 넥스트 사의 유물... 서브클래스가 오브젝트나 어떤 값을 메모리 - 다른 포맷 간에 변환할 수 있도록 지원함.
    // archiving (오브젝트나 데이터의 저장) 및 distribution (오브젝트나 데이터의 프로세스 또는 스레드 간 복사) 등의 작업을 위해 사용됨.
    required init?(coder: NSCoder) {  // ?: 생성자가 없을 수도 있음.
        fatalError("init(coder:) has not been implemented")  // 생성자가 없을 경우 오류를 발생시킴.
    }

    override public init(layer: Any) {  // layer: 부모 레이어의 인스턴스. Any: 모든 타입의 인스턴스.
        super.init(layer: layer)
    }


    // 스펙트로그램 프로퍼티 정의
    // sampleCount: DCT(이산 코사인 변환)를 통과하는 샘플 갯수 및 표시되는 진동수의 해상도. MARK: 변경 금지
    // 관련 문서: https://en.wikipedia.org/wiki/Discrete_cosine_transform
    static let sampleCount = 1024

    // bufferCount: 표시되는 버퍼 수. 버퍼 카운트가 커질 수록 느려짐
    static let bufferCount = 1000

    // hopCount: 버퍼가 오버랩되는 정도. 오버랩이 커질 수록 느려짐
    static let hopCount = 500

}
