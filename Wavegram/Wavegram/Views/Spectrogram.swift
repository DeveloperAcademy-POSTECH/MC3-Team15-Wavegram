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


    // AVCaptureAudioDataOutput() 추가
    // 오디오 녹음 + 오디오 샘플 버퍼에 액세스를 제공하는 캡쳐
    // 관련 문서: https://developer.apple.com/documentation/avfoundation/avcaptureaudiodataoutput
    let audioOutput = AVCaptureAudioDataOutput()

    let captureQueue = DispatchQueue(
            label: "captureQueue",
            qos: .userInitiated,
            autoreleaseFrequency: .workItem
    )

    let sessionQueue = DispatchQueue(
            label: "sessionQueue",
            attributes: [],
            autoreleaseFrequency: .workItem
    )

    let captureSession = AVCaptureSession()

    let dispatchSemaphore = DispatchSemaphore(value: 1)
}


/*
 @method captureOutput:didOutputSampleBuffer:fromConnection:
 @abstract Called whenever an AVCaptureAudioDataOutput instance outputs a new audio sample buffer.
 */
extension Spectrogram: AVCaptureAudioDataOutputSampleBufferDelegate {

    // MARK: 오디오 캡쳐 정의
    // TODO: 드록바가 작성한 코드와 비교/선택 필요

    // 오디오 캡쳐 환경설정(Configuration): AVCaptureSession 인스턴스 설정
    func configureAudiopCaptureSession() {

        // MARK: Code block starts here ---> 하단의 commitConfiguration()과 페어
        captureSession.beginConfiguration()


        // MARK: AVCaptureSession 인스턴스의 위치 마크
        // beginConfiguration() 과 commitConfiguration() 사이에 위치
        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        } else {
            fatalError("Caanot add an audioOutput.")
        }

        // 빌트-인 마이크 정의
        guard
            let microphone = AVCaptureDevice.default(
                .builtInMicrophone,
                for: .audio,
                position: .unspecified
            ),
            let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
                fatalError("Caanot create the microphone.")
        }

        if captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        } else {
            fatalError("Cannot add an audioInput.")
        }

        // MARK: Code block ends here <--- 윗단의 beginConfiguration()과 페어
        captureSession.commitConfiguration()
    }


}
