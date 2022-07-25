//
//  Spectrogram.swift
//  spectrogram_test
//
//  Created by 김제필 on 7/18/22.
//

import AVFoundation
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
        // DispatchQueue: 스레드 큐. 스레드를 생성하고 실행하는 객체.
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

    // 스펙트럼 누출(spectral leakage) 감소를 위한 코드
    // 해닝 윈도우로 신호 정보를 증폭하고 DCT를 수행
    // 스펙트럼 누출 감소를 위한 이산 푸리에 변환(DFT) + 윈도우 사용(Windowing) 방법: https://developer.apple.com/documentation/accelerate/using_windowing_with_discrete_fourier_transforms
    let hanningWindow = vDSP.window(
        ofType: Float.self,
        usingSequence: .hanningDenormalized,
        count: sampleCount,
        isHalfWindow: false
    )

    let forwardDCT = vDSP.DCT(
        count: sampleCount,
        transformType: .II
        /*
         vDSP.DCTTransformType.II

         N: the length given in the setup.
         h: the input array that contains real numbers.
         H: the output array that contains real numbers.

         For 0 <= k < N
             Or[k] = sum(Ir[j] * cos(k * (j+1/2) * pi / N, 0 <= j < N)

         관련 문서: https://developer.apple.com/documentation/accelerate/vdsp/dcttransformtype/
         */
    )!



    static var redTable: [Pixel_8] = (0...255).map {
        return brgValue(from: $0).red
    }

    static var greenTable: [Pixel_8] = (0...200).map {
        return brgValue(from: $0).green
    }

    static var blueTable: [Pixel_8] = (0...200).map {
        return brgValue(from: $0).blue
    }



    // 최고 주파수.
    // AudioSpectrogram.captureOutput(_:didOutput:from:) 첫 호출시 계산됨
    var nyquistFrequency: Float?

    var rawAudioData = [Int16]()

    // timeDomainBuffer: 오디오 데이터의 현재 프레임의 시간 영역을 단정밀도(single-precision) 값으로 내포하는 배열.
    // 코드 재사용을 위해 정의: 각 iteration별로 어레이를 만드는 상황을 방지하기 위함
    var timeDomainBuffer = [Float](
        repeating: 0,
        count: sampleCount
    )

    var frequencyDomainValues = [Float](
        repeating: 0,
        count: bufferCount * sampleCount
    )

    var frequencyDomainBuffer = [Float](
        repeating: 0,
        count: sampleCount
    )

    var maxFloat: Float = {
        var maxValue = [Float(Int16.max)]
        vDSP.convert(
            amplitude: maxValue,
            toDecibels: &maxValue,
            zeroReference: Float(Spectrogram.sampleCount)
        )
        return maxValue[0] * 2
    }()

    // vImage buffer -> to display spectrogram
    // 높이: sampleCount, 너비: bufferCount
    // 스펙트로그램의 수평 렌더링 및 스크롤링을 위한 코드
    var rgbImageFormat: vImage_CGImageFormat = {
        guard let format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 8 * 4,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            renderingIntent: .defaultIntent
        ) else {
            fatalError("Cannot create image format.")
        }
        return format
    }()



    // MARK: ---> RGB 이미지 버퍼
    // 수직 방향 이미지 버퍼
    lazy var rgbImageBuffer: vImage_Buffer = {
        guard let buffer = try? vImage_Buffer(
            width: Spectrogram.sampleCount,
            height: Spectrogram.bufferCount,
            bitsPerPixel: rgbImageFormat.bitsPerPixel
        )
        else {
            fatalError("Unable to initialize image buffer.")
        }
        return buffer
    }()

    // 수평 방향 이미지 버퍼
    lazy var rotatedImageBuffer: vImage_Buffer = {
        guard let buffer = try? vImage_Buffer(
            width: Spectrogram.bufferCount,
            height: Spectrogram.sampleCount,
            bitsPerPixel: rgbImageFormat.bitsPerPixel
        ) else {
            fatalError("Unable to initialize rotate image buffer.")
        }
        return buffer
    }()
    // MARK: <---


    // 소멸자: 이미지 버퍼 제거
    deinit {
        rgbImageBuffer.free()
        rotatedImageBuffer.free()
    }


    /*
     processData(values: ): DCT(이산 코사인 변환) + 스펙트로그램 이미지를 생성하는 배열에 주파수 영역에 대한 데이터 추가
        -> vImage 버퍼 및 스펙트로그램 생성
     MARK: Int16 데이터 값 -> 단차원 변환(이산 코사인 변환; DCT)
     */
    func processData(values: [Int16]) {
        dispatchSemaphore.wait()

        /*
         vDSP: 큰 벡터에 대한 기본 연산 + 디지털 신호 처리 루틴 처리 API
         관련 문서: https://developer.apple.com/documentation/accelerate/vdsp

         convertElements(of:to:): 16-bit int -> 단정밀도 부동소수점 컨버팅
         관련 문서 1: https://developer.apple.com/documentation/accelerate/vdsp/3240881-convertelements/
         관련 문서 2: https://developer.apple.com/documentation/accelerate/vdsp/3240989-integertofloatingpoint
         */
        vDSP.convertElements(
            of: values,
            to: &timeDomainBuffer
        )

        // 해닝 윈도우에서 시간 영역 데이터를 증폭하고 DCT 수행
        // MARK: --->
        vDSP.multiply(
            timeDomainBuffer,
            hanningWindow,
            result: &timeDomainBuffer
        )

        forwardDCT.transform(
            timeDomainBuffer,
            result: &frequencyDomainBuffer
        )
        // MARK: <---



        // MARK: forward transform 후 수행되는 작업
        // 진동수(frequency) -> 데시벨
        // 스펙트로그램 색깔 <--> 소리 크기(데시벨) 변환
        vDSP.absolute(
            frequencyDomainBuffer,
            result: &frequencyDomainBuffer
        )
        vDSP.convert(
            amplitude: frequencyDomainBuffer,
            toDecibels: &frequencyDomainBuffer,
            zeroReference: Float(Spectrogram.sampleCount)
        )

        if frequencyDomainValues.count > Spectrogram.sampleCount {
            frequencyDomainValues.removeFirst(Spectrogram.sampleCount)
        }

        frequencyDomainValues.append(contentsOf: frequencyDomainBuffer)

        dispatchSemaphore.signal()
    }


    // MARK: 스펙트로그램 생성
    func createSpectrogram() {
        let maxFloats: [Float] = [255, maxFloat, maxFloat, maxFloat]
        let minFloats: [Float] = [255, 0, 0, 0]

        frequencyDomainValues.withUnsafeMutableBufferPointer {
            var planarImageBuffer = vImage_Buffer(
                data: $0.baseAddress!,
                height: vImagePixelCount(Spectrogram.bufferCount),
                width: vImagePixelCount(Spectrogram.sampleCount),
                rowBytes: Spectrogram.sampleCount * MemoryLayout<Float>.stride
            )

            vImageConvert_PlanarFToARGB8888(
                &planarImageBuffer,
                &planarImageBuffer,
                &planarImageBuffer,
                &planarImageBuffer,
                &rgbImageBuffer,
                maxFloats,
                minFloats,
                vImage_Flags(kvImageNoFlags)
            )
        }

        // 색 버퍼 변환
        vImageTableLookUp_ARGB8888(
            &rgbImageBuffer,
            &rgbImageBuffer,
            nil,
            &Spectrogram.redTable,
            &Spectrogram.greenTable,
            &Spectrogram.blueTable,
            vImage_Flags(kvImageNoFlags)
        )

        // 색 버퍼 90º 회전
        vImageRotate90_ARGB8888(
            &rgbImageBuffer,
            &rotatedImageBuffer,
            UInt8(kRotate90DegreesCounterClockwise),
            [UInt8()],
            vImage_Flags(kvImageNoFlags)
        )

        if let image = try? rotatedImageBuffer.createCGImage(format: rgbImageFormat) {
            DispatchQueue.main.async {
                self.contents = image
            }
        }
    }
}



extension Spectrogram {
    /*
     MARK: ---> False-color Lookup Tables

     false-color 룩업 테이블을 위한 코드
     파랑 -> 빨강 -> 초록 순서로 변화

     false-color: https://terms.naver.com/entry.naver?docId=843190&cid=42346&categoryId=42346
     */
    typealias Color = UIColor

    static func brgValue(from value: Pixel_8) -> (
        red: Pixel_8,
        green: Pixel_8,
        blue: Pixel_8
    ) {
        let normalizedValue = CGFloat(value) / 255
        let colorRange = 0.6666 - (0.6666 * normalizedValue)
        let brightness = sqrt(normalizedValue)

        let color = Color(
            hue: colorRange,
            saturation: 1,
            brightness: brightness,
            alpha: 1
        )

        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()

        color.getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: nil
        )

        return (
            Pixel_8(red * 255),
            Pixel_8(green * 255),
            Pixel_8(blue * 255)
        )
    }
    // MARK: <---
}
