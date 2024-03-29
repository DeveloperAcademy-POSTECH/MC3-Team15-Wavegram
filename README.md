# MC3-Team15-Wavegram
Wavegram

## Members
<!-- |Drogba|Raymond|Alice|
|:---|:---|:---| -->
| [Drogba](https://github.com/iDrogba) | [Raymond](https://wwww.github.com/garlicvread) | [Alice](https://github.com/ejalice) | [Woody](https://github.com/insub4067) | [Milky](https://github.com/Hyogyong) |

<br>

## Git Commit Message
### 커밋 메시지 구조

<br>

> type: Subject<br><br>
> body<br><br>
> footer

<br>

### Type
타입에는 작업 타입을 나타내는 태그를 적습니다.<br>
작업 타입에는 대략 다음과 같은 종류가 있습니다.
|*Type*|*Subject*|
|:---|:---|
|**[Feat]**|새로운 기능 추가|
|**[Add]**|새로운 뷰, 에셋, 파일, 데이터... 추가|
|**[Fix]**|버그 수정|
|**[Build]**|빌드 관련 파일 수정|
|**[Design]**|UI Design 변경|
|**[Docs]**|문서 (문서 추가, 수정, 삭제)|
|**[Style]**|스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없는 경우)|
|**[Refactor]**|코드 리팩토링|
|**[Rename]**|파일명 또는 디렉토리명을 단순히 변경만 한 경우|
|**[Delete]**|파일 또는 디렉토리를 단순히 삭제만 한 경우|

예시) [Type] #이슈번호 커밋메세지 `git commit -m "[Feat] #12 로그인 기능 추가"`

### Issue

- Issue 의 title 시작을 tag로 시작한다

- PR를 올리기 전에 Issue를 생성하고 연결한다

- 작업에 대한 원인과 흐름등을 설정한다

### PR

- PR 의 title 시작을 tag로 시작한다

- Title 은 작업된 File 이름 혹은 기능 이름으로 한다

- 최소 2명의 Approve

- PR를 올리기 전에 Issue를 생성하고 연결한다

- 단위 : 수정/추가된 기능 혹은 File 단위로 한다.

### Commit

- Commit 의 title 시작을 tag로 시작한다

- Title 은 작업된 File 이름 혹은 기능 이름으로 한다

- Commit 의 description 에는 작업된 상세 내용이 들어간다

- Description에는 작업한 내용과 To Reviewers 로 review 할 내용을 전달한다

- 단위 : 같은 File 혹은 기능내에서 가능한 작은 단위의 기능으로 쪼개어 commit 한다 얘) func , class, component 등

### Project ToDo

- 개인의 할일 Reminder 로 사용한다

<br>

### Subject(필수)
서브젝트는 50글자가 넘지 않도록 작성합니다.<br>
서브젝트는 마침표를 찍지 않습니다.<br>
영어로 작성하는 경우 첫 문자는 대문자로 작성합니다.<br>

### Body(옵셔널)
바디는 서브젝트에서 한 줄 건너뛰고 작성합니다.<br>
바디는 없어도 큰 문제가 없는 경우도 많습니다. 따라서 항상 작성해야 하는 부분은 아닙니다.<br>
설명해야 하는 변경점이 있는 경우에만 작성하도록 합시다!<br>
바디에는 뭐가 어떻게 변경됐다는 구체적 정보보다는 왜 이 작업을 했는지에 대한 정보를 적는 것이 좋습니다.<br>

### Footer(옵셔널)
푸터도 바디와 마찬가지로 옵션입니다.<br>
푸터의 경우 일반적으로 트래킹하는 이슈가 있는 경우 트래커 ID를 표기할 때 사용합니다.<br>
'#' 를 누르면 이슈 번호나 커밋 번호를 확인할 수 있습니다.<br>
필요한 경우 푸터를 남겨주세요!

<br>

## Git Pull Request Message
[태스크] >> 브랜치 명

예시) [추가 모달 뷰 연결] >> addModalView

<br>
