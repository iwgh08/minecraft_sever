# 친구들이랑 하는 마인크래프트 서버

- 버전: Minecraft Java **26.3** (Paper)
- Java: Eclipse Temurin 25 (`C:\Program Files\Eclipse Adoptium\jre-25*`)
- 접속 주소: 서버 컴퓨터의 `server-address.txt` 에 있어요 (playit.gg 무료 터널. 공개 저장소라 여기엔 안 적어요)
- 플러그인: Chunky (월드 미리 만들기), NMinimap (미니맵), PacketEvents·AnvilORM (NMinimap에 필요한 플러그인)
- 데이터팩: NoMod Shaders (셰이더 효과를 각자 고르는 명령. `server\world\datapacks\` 에 있어서 백업에 같이 들어가요)

## 친구 접속 방법
1. 마인크래프트 Java 에디션 **26.3** 실행
2. 멀티플레이 → 서버 추가 → 주소에 위 접속 주소 입력
3. 처음 접속할 때 리소스팩을 받을지 묻는 창이 뜨면 **예** (미니맵과 셰이더 효과용. 아래 "미니맵과 셰이더 효과" 참고)
4. 접속이 안 되면 → 서버 콘솔에서 그 친구 닉네임으로 `whitelist add` 했는지 확인

본인은 같은 컴퓨터에서 `localhost` 로 접속하면 돼요.

## 미니맵과 셰이더 효과
모드를 안 깐 기본 마인크래프트에서 보여요. 접속할 때 서버가 리소스팩을 보내주고, 그 팩이 화면에 그려요.
- 리소스팩 창에서 **예**를 눌러야 보여요. "아니오"를 눌렀다면: 멀티플레이 목록에서 서버 선택 → 편집 →
  "서버 리소스 팩"을 "사용"으로 바꾸고 다시 접속
  (팩 없이 들어오면 미니맵이 이상하게 보일 수 있어요. 팩을 안 쓸 거면 `/minimap disable`)
- **미니맵**: 오른쪽 위에 떠요. 각자 채팅창에 입력해서 바꿔요

  | 명령어 | 설명 |
  |---|---|
  | `/minimap disable` / `/minimap enable` | 미니맵 끄기 / 켜기 |
  | `/minimap scale 1` (2, 4, 8) | 숫자가 클수록 더 넓은 범위가 보여요 |
  | `/minimap style round` / `/minimap style square` | 둥근 지도 / 네모 지도 |
  | `/minimap side left` / `/minimap side right` | 왼쪽 위 / 오른쪽 위 |
  | `/minimap radar disable` / `/minimap radar enable` | 지도에 몹 표시 끄기 / 켜기 |

- **셰이더 효과**: 흔들리는 나뭇잎·풀, 노을빛, 횃불빛, 빛 번짐, 그림자 느낌, 색감 보정. 각자 채팅창에 입력해서 골라요

  | 명령어 | 설명 |
  |---|---|
  | `/trigger shaders_lite` | 가볍게 (색감과 빛 번짐만, 가장 빠름) |
  | `/trigger shaders_default` | 기본 (처음 상태) |
  | `/trigger shaders_cinematic` | 영화처럼 (먼 곳 흐림까지) |
  | `/trigger shaders_off` | 효과 끄기 |

  해 그림자, 반사, 물결은 없어요. Iris 같은 셰이더 모드보다 가벼운 효과예요.
- 이럴 때는 서버 미니맵이 안 보여요:
  - Iris나 OptiFine 셰이더를 켰거나, ImmediatelyFast 모드를 쓰는 경우 → 그 친구는 Xaero's Minimap 모드를 깔면 돼요
  - Fabric 같은 모드 로더로 실행한 경우 자동으로 안 켜져요 → 셰이더 모드가 없으면 `/minimap enable`

## 서버 켜기 / 끄기
- **켜기**: `start.bat` 더블클릭
  (윈도우를 켜도 서버는 자동으로 안 켜져요. 직접 실행해야 켜져요)
- **끄기**: 서버 콘솔 창에 `stop` 입력 → "Restart now?" 질문에 `N`
  (그냥 두면 10초 뒤 자동 재시작돼요. 서버가 튕겨도 자동으로 다시 켜져요)
- 콘솔 창을 X로 닫으면 저장이 안 될 수 있으니 꼭 `stop` 으로 끄세요.

## 자주 쓰는 콘솔 명령어 (서버 콘솔 창에 입력, `/` 없이)
| 명령어 | 설명 |
|---|---|
| `whitelist add 닉네임` | 친구 접속 허용 |
| `whitelist remove 닉네임` | 접속 허용 취소 |
| `whitelist list` | 허용된 사람 목록 |
| `op 닉네임` | 관리자 권한 주기 (본인 닉네임에 먼저 해두세요) |
| `list` | 지금 접속한 사람 |
| `save-all` | 즉시 저장 |
| `stop` | 서버 끄기 |

## 렉이 심할 때
- 서버가 느린 건지 확인: 서버 콘솔에 `spark tps` → MSPT 최대값이 50을 자주 넘으면 서버 문제,
  아니면 네트워크 문제예요
- 마인크래프트 옵션 → 비디오 설정 → **렌더 거리** 낮추기 (그 사람이 받는 땅 데이터만 줄어요)
- 미니맵이 생긴 뒤로 느려졌다면: `server\plugins\NMinimap\config.yml` 의 `player-render-interval: 1` 을 `2` 로
  바꾸고 서버 재시작 (지도를 1초에 20번 → 10번 새로 그려요)
- Windows 전력 제한 해제 (이미 적용됨): `java.exe`, `playitd.exe` (덮개를 닫아도 CPU를 제대로 씀)
  Java를 업데이트하면 경로가 바뀌니 관리자 PowerShell에서 다시:
  `powercfg /powerthrottling disable /path "<새 java.exe 경로>"`

## 월드 미리 만들기 (Chunky)
새 지역에 처음 가면 서버가 그 자리에서 땅을 만드느라 끊겨요. 미리 만들어두면 탐험할 때 부드러워요.
| 명령어 | 설명 |
|---|---|
| `chunky radius 2000` | 스폰 중심 반지름 2000블록으로 범위 설정 |
| `chunky start` | 미리 만들기 시작 (진행률이 콘솔에 나와요) |
| `chunky pause` / `chunky continue` | 잠깐 멈추기 / 이어서 하기 |
| `chunky cancel` | 취소 |
- 친구들이 없을 때 돌리는 게 좋아요. 서버를 껐다 켜도 `chunky continue` 로 이어서 할 수 있어요.

## 백업
- 매일 새벽 5시 자동 백업 → `backups\world-날짜-시간.zip` (최근 7개만 유지)
- 지금 바로 백업: Claude Code에서 `/backup` 입력 (서버 점검 → 백업 → 백업 파일 검사까지 해줘요)
  또는 `backup.ps1` 우클릭 → "PowerShell에서 실행"
- 복원: 서버 `stop` → `server\world` 폴더를 다른 이름으로 바꿔두고 → zip 안의 `world` 폴더를 `server\` 에 풀기 → 서버 다시 켜기

## playit.gg (외부 접속 터널)
- 터널: Minecraft Java (→ 127.0.0.1:25565)
- 윈도우 서비스 `playitd` 로 부팅 시 자동 실행 (와이파이 연결을 기다리도록 지연 시작, 꺼지면 1분 뒤 자동 재시작)
- 터널/주소 관리: https://playit.gg 로그인 → Agents / Tunnels
- 상태 확인: `"C:\Program Files\playit_gg\bin\playit.exe" status`

## 24시간 운영 설정 (이미 적용됨)
- 충전기 연결 시: 절전·최대 절전 안 함, 화면 자동 꺼짐 안 함, 덮개 닫아도 계속 동작
  (이 노트북은 화면이 꺼지면 "모던 스탠바이"라는 반절전에 들어가서 친구들 접속이 끊길 수 있어요.
  화면은 **덮개를 닫아서** 끄세요)
- 친구들이 노는 중에는 시작 메뉴 → **절전 누르지 않기** (서버가 통째로 멈춰요)
- **시스템 종료 / 로그아웃하면 서버도 꺼져요.** 다시 켜고 로그인한 뒤 `start.bat` 을 실행하세요
  (`start.bat` 이 인터넷 연결을 기다렸다가 켜요. 인터넷보다 먼저 켜지면 Mojang 로그인 서버 정보를 못 받아서
  친구들이 한동안 못 들어올 수 있기 때문)
- 서버 로그에 `Services are unavailable` 오류가 보이면: 인터넷이 늦게 연결된 거예요 → 서버 `stop` 으로 재시작
- 배터리일 때도 덮개를 닫아도 계속 동작하게 바꿔둠 (충전기가 없을 때를 위해)
  → **가방에 넣을 때는 꼭 시작 메뉴에서 절전/종료**하세요. 안 그러면 가방 안에서 계속 돌아서 뜨거워져요
  → 배터리가 2%가 되면 자동으로 최대 절전에 들어가서 서버가 멈춰요
  → 충전기를 다시 쓰게 되면 원래대로(배터리일 때 덮개 닫으면 절전): 관리자 아닌 PowerShell에서
    `powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1; powercfg /setactive SCHEME_CURRENT`
- 노트북 발열 주의: 통풍 잘 되는 곳에 두기

## 설정 파일
- `server\server.properties`: 화이트리스트 강제, 최대 5명, 난이도 normal, view-distance 10, simulation-distance 8,
  `enforce-secure-profile=false` (보안 채팅 강제 끔)
  (비밀값이 있어서 GitHub에는 그 값을 지운 `server\server.properties.example` 만 올려요)
  - `resource-pack=` 로 시작하는 줄들: 친구들에게 보내는 리소스팩의 주소, SHA-1(파일 검사값), 안내 문구
  - `require-resource-pack=false`: 팩을 거절해도 접속은 돼요. `true` 로 바꾸면 거절한 사람은 못 들어와요
- `server\plugins\NMinimap\config.yml` (미니맵 설정). 기본값에서 바꾼 것:
  - `side: right`: 오른쪽 위에 표시
  - `map-id: 1000000`: 미니맵이 빌려 쓰는 지도 번호. 월드에 이미 있는 지도(0~12번)와 겹치지 않게 바꿨어요.
    **0으로 되돌리면 친구들이 만든 0번 지도가 망가져요**
  - `mods-compatibility.mode: 2`: Xaero's 같은 미니맵 모드를 깐 친구는 그 모드가 그대로 보여요
  - `static-markers: {}`: 좌표 0,0에 깃발을 표시하는 예시 설정을 지웠어요
- `server\config\paper-global.yml` (Paper가 기본으로 막아둔 바닐라 기술들을 허용함.
  원래대로 막으려면 `false` 로 바꾸고 서버 재시작):
  - `allow-piston-duplication: true` (TNT·레일·카펫 복사기)
  - `allow-headless-pistons: true` (머리 없는 피스톤)
  - `allow-permanent-block-break-exploits: true` (기반암·엔드 포털 틀 부수기)
- `start.bat`: 메모리 4~6GB 할당 (`-Xms4G -Xmx6G`)

## 리소스팩 다시 만들기
이럴 때 팩을 다시 만들어야 해요:
- NMinimap의 지도 크기나 위치(`map-pixel-size`, `map-display`)를 바꿨을 때
- NMinimap이나 NoMod Shaders를 새 버전으로 바꿨을 때

Claude Code에 "리소스팩 다시 만들어줘"라고 하면 돼요. 직접 하려면:
1. 서버를 껐다 켜기 (NMinimap이 `server\plugins\NMinimap\built-pack.zip` 을 새로 만들어요)
2. PowerShell에서 실행 (숫자는 지난번보다 1 크게):
   `powershell -NoProfile -ExecutionPolicy Bypass -File resourcepack\build-pack.ps1 -Version 2`
3. 새 zip을 GitHub에 올리기: `git add resourcepack\minimap-shaders-v2.zip` → 커밋 → `git push`
4. 2번에서 출력된 `resource-pack=` 줄과 `resource-pack-sha1=` 줄을 `server\server.properties` 에 바꿔 넣고 서버 재시작

- 지금 쓰는 팩: `resourcepack\minimap-shaders-v1.zip` (공개 저장소에서 친구들이 받아가요)
- 파일 이름의 숫자를 매번 바꾸는 이유: 이름이 같으면 GitHub가 몇 분 동안 옛날 파일을 줘서, 친구들이 팩을 못 받아요
- NoMod Shaders를 새 버전으로 바꿀 때는 `resourcepack\sources\` 의 리소스팩 zip, `build-pack.ps1` 안의 파일 이름,
  `server\world\datapacks\` 의 데이터팩을 같이 바꿔야 해요

## 서버 버전 업데이트
- **주의: 26.4 이상으로 올리기 전에** NMinimap과 NoMod Shaders가 그 버전을 지원하는지 먼저 확인하세요.
  둘 다 게임 버전마다 바뀌는 그래픽 코드를 써서, 지원하기 전에 올리면 미니맵과 셰이더 효과가 안 보이거나
  화면이 깨질 수 있어요 (26.4부터 그래픽 방식이 크게 바뀔 예정이에요).
  같은 26.3 안에서 Paper만 새 빌드로 바꾸는 건 괜찮아요.

1. 서버 `stop` + 백업
2. https://papermc.io/downloads/paper 에서 새 jar 받아서 `server\paper.jar` 로 교체
3. 새 버전이 더 높은 Java를 요구하면 `winget install EclipseAdoptium.Temurin.<버전>.JRE` 후 `start.bat` 의 `jre-25*` 부분 수정
