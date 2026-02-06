"""이메일 도메인 검증 모듈"""

# 개인 이메일 도메인 블랙리스트 (가입 불가)
PERSONAL_EMAIL_BLACKLIST = {
    # 글로벌
    "gmail.com",
    "googlemail.com",
    "outlook.com",
    "hotmail.com",
    "live.com",
    "msn.com",
    "yahoo.com",
    "yahoo.co.kr",
    "icloud.com",
    "me.com",
    "mac.com",
    "protonmail.com",
    "proton.me",
    "aol.com",
    "zoho.com",
    "yandex.com",
    "mail.com",
    "gmx.com",
    "tutanota.com",
    # 한국 개인 이메일
    "naver.com",
    "hanmail.net",
    "daum.net",
    "kakao.com",
    "nate.com",
    "empal.com",
    "dreamwiz.com",
    "korea.com",
    "chol.com",
    "freechal.com",
    "paran.com",
    "lycos.co.kr",
    "hanmir.com",
    "netian.com",
}

# 대한민국 주요 기업 도메인 화이트리스트
# 형식: (도메인, 회사명, 산업군)
KOREAN_COMPANY_WHITELIST = [
    # === 삼성그룹 ===
    ("samsung.com", "삼성전자", "IT/전자"),
    ("samsungsds.com", "삼성SDS", "IT/SI"),
    ("samsungcnt.com", "삼성물산", "건설/상사"),
    ("samsungfire.com", "삼성화재", "금융/보험"),
    ("samsunglife.com", "삼성생명", "금융/보험"),
    ("samsungcard.com", "삼성카드", "금융"),
    ("samsungsecurities.com", "삼성증권", "금융"),
    ("samsungheavy.com", "삼성중공업", "조선"),
    ("samsungengineering.com", "삼성엔지니어링", "건설"),
    ("samsungelectro.com", "삼성전기", "전자부품"),
    ("sdi.samsung.com", "삼성SDI", "배터리"),
    ("samsungbio.com", "삼성바이오로직스", "바이오"),
    ("cheil.com", "제일기획", "광고"),
    ("hotel-shilla.com", "호텔신라", "호텔"),

    # === SK그룹 ===
    ("sk.com", "SK주식회사", "지주"),
    ("skhynix.com", "SK하이닉스", "반도체"),
    ("sktelcom.com", "SK텔레콤", "통신"),
    ("sktelecom.com", "SK텔레콤", "통신"),
    ("skplanet.com", "SK플래닛", "IT"),
    ("skenergy.com", "SK에너지", "에너지"),
    ("skinnovation.com", "SK이노베이션", "에너지"),
    ("skchemicals.com", "SK케미칼", "화학"),
    ("sknetworks.co.kr", "SK네트웍스", "상사"),
    ("sksquare.com", "SK스퀘어", "투자"),
    ("skcc.co.kr", "SK C&C", "IT/SI"),
    ("skcorp.com", "SK", "지주"),
    ("sk-inc.com", "SK Inc.", "지주"),
    ("skens.com", "SK E&S", "에너지"),
    ("skon.co.kr", "SK온", "배터리"),

    # === 현대자동차그룹 ===
    ("hyundai.com", "현대자동차", "자동차"),
    ("hyundai-motor.com", "현대자동차", "자동차"),
    ("kia.com", "기아", "자동차"),
    ("mobis.co.kr", "현대모비스", "자동차부품"),
    ("hyundai-steel.com", "현대제철", "철강"),
    ("hmc.co.kr", "현대자동차", "자동차"),
    ("hyundai-transys.com", "현대트랜시스", "자동차부품"),
    ("hyundai-autoever.com", "현대오토에버", "IT"),
    ("hyundaicard.com", "현대카드", "금융"),
    ("hyundaicapital.com", "현대캐피탈", "금융"),
    ("hyundai-ims.com", "현대아이엠에스", "IT"),
    ("hyundaiglovis.com", "현대글로비스", "물류"),
    ("hyundaieng.com", "현대건설", "건설"),
    ("hyundai-rotem.com", "현대로템", "철도"),
    ("hyundai-ite.com", "현대IT&E", "IT"),
    ("hmgjournal.com", "현대차그룹", "지주"),

    # === HD현대그룹 ===
    ("hd.com", "HD현대", "지주"),
    ("hhi.co.kr", "HD현대중공업", "조선"),
    ("hhieng.com", "HD현대건설기계", "건설기계"),
    ("hdoilbank.com", "HD현대오일뱅크", "에너지"),

    # === LG그룹 ===
    ("lg.com", "LG", "지주"),
    ("lge.com", "LG전자", "IT/전자"),
    ("lgchem.com", "LG화학", "화학"),
    ("lgensol.com", "LG에너지솔루션", "배터리"),
    ("lgdisplay.com", "LG디스플레이", "디스플레이"),
    ("lginnotek.com", "LG이노텍", "전자부품"),
    ("lgcns.com", "LG CNS", "IT/SI"),
    ("lguplus.co.kr", "LG유플러스", "통신"),
    ("lguplus.com", "LG유플러스", "통신"),
    ("lghellovision.net", "LG헬로비전", "통신"),
    ("lghnh.com", "LG생활건강", "생활용품"),

    # === GS그룹 ===
    ("gs.co.kr", "GS", "지주"),
    ("gscaltex.com", "GS칼텍스", "에너지"),
    ("gsretail.com", "GS리테일", "유통"),
    ("gsenc.com", "GS건설", "건설"),
    ("gseps.com", "GS EPS", "전력"),

    # === 롯데그룹 ===
    ("lotte.co.kr", "롯데", "지주"),
    ("lottechem.com", "롯데케미칼", "화학"),
    ("lotteshopping.com", "롯데쇼핑", "유통"),
    ("lottecard.co.kr", "롯데카드", "금융"),
    ("lotteans.com", "롯데정보통신", "IT"),
    ("lottecon.co.kr", "롯데건설", "건설"),
    ("lotteglobal.com", "롯데글로벌로지스", "물류"),
    ("lottefnd.com", "롯데푸드", "식품"),
    ("lottehotel.com", "롯데호텔", "호텔"),

    # === 한화그룹 ===
    ("hanwha.com", "한화", "지주"),
    ("hanwha.co.kr", "한화", "지주"),
    ("hanwhalife.com", "한화생명", "금융/보험"),
    ("hanwhasystems.com", "한화시스템", "방산/IT"),
    ("hanwhasolutions.com", "한화솔루션", "화학"),
    ("hanwhaaero.co.kr", "한화에어로스페이스", "방산"),
    ("hanwhaqcells.com", "한화큐셀", "에너지"),
    ("hanwhaoilbank.com", "한화오일뱅크", "에너지"),

    # === 포스코그룹 ===
    ("posco.com", "포스코홀딩스", "철강"),
    ("posco.co.kr", "포스코", "철강"),
    ("poscoenc.com", "포스코건설", "건설"),
    ("poscochemical.com", "포스코케미칼", "화학"),
    ("poscoict.com", "포스코ICT", "IT"),
    ("poscofuturem.com", "포스코퓨처엠", "소재"),

    # === 두산그룹 ===
    ("doosan.com", "두산", "지주"),
    ("doosanrobotic.com", "두산로보틱스", "로봇"),
    ("doosanbobcat.com", "두산밥캣", "건설기계"),
    ("doosanenerbility.com", "두산에너빌리티", "에너지"),

    # === CJ그룹 ===
    ("cj.net", "CJ", "지주"),
    ("cjlogistics.com", "CJ대한통운", "물류"),
    ("cjcheiljedang.com", "CJ제일제당", "식품"),
    ("cgv.co.kr", "CJ CGV", "영화"),
    ("cjenm.com", "CJ ENM", "미디어"),
    ("cjfreshway.com", "CJ프레시웨이", "식품유통"),
    ("oliveyoung.co.kr", "올리브영", "유통"),

    # === 신세계그룹 ===
    ("shinsegae.com", "신세계", "유통"),
    ("emart.com", "이마트", "유통"),
    ("ssg.com", "SSG닷컴", "이커머스"),
    ("ssgdfs.com", "신세계면세점", "면세"),
    ("starbucks.co.kr", "스타벅스코리아", "F&B"),

    # === 금융 ===
    # 은행
    ("shinhan.com", "신한은행", "금융"),
    ("kbfg.com", "KB금융", "금융"),
    ("kbstar.com", "KB국민은행", "금융"),
    ("wooribank.com", "우리은행", "금융"),
    ("hanabank.com", "하나은행", "금융"),
    ("ibk.co.kr", "IBK기업은행", "금융"),
    ("nh.co.kr", "NH농협은행", "금융"),
    ("nonghyup.com", "NH농협", "금융"),
    ("kdb.co.kr", "KDB산업은행", "금융"),
    ("koreaexim.go.kr", "한국수출입은행", "금융"),
    ("suhyup.co.kr", "Sh수협은행", "금융"),
    ("kjbank.com", "광주은행", "금융"),
    ("jbbank.co.kr", "전북은행", "금융"),
    ("dgb.co.kr", "DGB대구은행", "금융"),
    ("bnkfg.com", "BNK금융", "금융"),
    ("busanbank.co.kr", "부산은행", "금융"),
    ("knbank.co.kr", "경남은행", "금융"),
    ("jeju.co.kr", "제주은행", "금융"),
    ("scbank.co.kr", "SC제일은행", "금융"),
    ("citibank.co.kr", "한국씨티은행", "금융"),
    ("kakaobank.com", "카카오뱅크", "금융"),
    ("kbanknow.com", "케이뱅크", "금융"),
    ("tossbank.com", "토스뱅크", "금융"),

    # 증권
    ("miraeasset.com", "미래에셋증권", "금융"),
    ("nhqv.com", "NH투자증권", "금융"),
    ("kbsec.co.kr", "KB증권", "금융"),
    ("shinhansec.com", "신한투자증권", "금융"),
    ("kiwoom.com", "키움증권", "금융"),
    ("hanaw.com", "하나증권", "금융"),
    ("samsungpop.com", "삼성증권", "금융"),
    ("daol.co.kr", "다올투자증권", "금융"),
    ("truefriend.com", "한국투자증권", "금융"),
    ("hi-ib.com", "하이투자증권", "금융"),
    ("myasset.com", "유안타증권", "금융"),
    ("kofia.or.kr", "금융투자협회", "금융"),
    ("iprovest.com", "교보증권", "금융"),

    # 보험
    ("samsunglife.com", "삼성생명", "금융/보험"),
    ("kyobo.co.kr", "교보생명", "금융/보험"),
    ("hanwhalife.com", "한화생명", "금융/보험"),
    ("nhlife.co.kr", "NH생명", "금융/보험"),
    ("samsungfire.com", "삼성화재", "금융/보험"),
    ("kbinsure.co.kr", "KB손해보험", "금융/보험"),
    ("meritzfire.com", "메리츠화재", "금융/보험"),
    ("dbinsure.co.kr", "DB손해보험", "금융/보험"),
    ("hwgeneralins.com", "한화손해보험", "금융/보험"),

    # === IT/플랫폼 ===
    ("naver.com", "네이버", "IT/플랫폼"),  # 회사 도메인으로 허용
    ("navercorp.com", "네이버", "IT/플랫폼"),
    ("kakaocorp.com", "카카오", "IT/플랫폼"),
    ("kakaoent.com", "카카오엔터테인먼트", "IT/미디어"),
    ("kakaopay.com", "카카오페이", "핀테크"),
    ("kakaomobility.com", "카카오모빌리티", "IT/모빌리티"),
    ("kakaogames.com", "카카오게임즈", "게임"),
    ("kakaobank.com", "카카오뱅크", "핀테크"),
    ("daangn.com", "당근마켓", "IT/플랫폼"),
    ("coupang.com", "쿠팡", "이커머스"),
    ("woowahan.com", "우아한형제들", "IT/플랫폼"),
    ("yanolja.com", "야놀자", "IT/플랫폼"),
    ("toss.im", "비바리퍼블리카", "핀테크"),
    ("line.me", "라인", "IT/플랫폼"),
    ("linecorp.com", "라인", "IT/플랫폼"),

    # === 게임 ===
    ("nexon.com", "넥슨", "게임"),
    ("nexon.co.kr", "넥슨", "게임"),
    ("ncsoft.com", "엔씨소프트", "게임"),
    ("netmarble.com", "넷마블", "게임"),
    ("smilegate.com", "스마일게이트", "게임"),
    ("krafton.com", "크래프톤", "게임"),
    ("bluehole.net", "블루홀", "게임"),
    ("com2us.com", "컴투스", "게임"),
    ("neowiz.com", "네오위즈", "게임"),
    ("pearl-abyss.com", "펄어비스", "게임"),
    ("gamevil.com", "게임빌", "게임"),
    ("devsisters.com", "데브시스터즈", "게임"),
    ("supercent.io", "슈퍼센트", "게임"),

    # === 통신 ===
    ("kt.com", "KT", "통신"),
    ("ktcloud.com", "KT클라우드", "IT/클라우드"),
    ("ktsat.com", "KT SAT", "통신/위성"),
    ("kth.co.kr", "KTH", "IT"),

    # === 전자/제조 ===
    ("samsungelec.co.kr", "삼성전자서비스", "전자"),
    ("sec.co.kr", "삼성전자", "전자"),
    ("hanon.co.kr", "한온시스템", "자동차부품"),
    ("magna.com", "마그나", "자동차부품"),
    ("mando.com", "만도", "자동차부품"),
    ("halla.com", "한라홀딩스", "지주"),

    # === 건설 ===
    ("daewooenc.com", "대우건설", "건설"),
    ("daelim.co.kr", "DL이앤씨", "건설"),
    ("dlenc.co.kr", "DL이앤씨", "건설"),
    ("hdec.kr", "HDC현대산업개발", "건설"),

    # === 항공/물류 ===
    ("koreanair.com", "대한항공", "항공"),
    ("jinair.com", "진에어", "항공"),
    ("flyasiana.com", "아시아나항공", "항공"),
    ("jejuair.net", "제주항공", "항공"),
    ("hanjin.co.kr", "한진", "물류"),
    ("hyundaimm.com", "현대해운", "물류"),

    # === 유통/소비재 ===
    ("amorepacific.com", "아모레퍼시픽", "화장품"),
    ("lgcare.com", "LG생활건강", "화장품"),
    ("ottogi.com", "오뚜기", "식품"),
    ("dongwon.com", "동원그룹", "식품"),
    ("nongshim.com", "농심", "식품"),
    ("orion.co.kr", "오리온", "식품"),
    ("lottewellfood.com", "롯데웰푸드", "식품"),
    ("samyang.com", "삼양식품", "식품"),
    ("hy.co.kr", "한국야쿠르트", "식품"),
    ("pulmuone.com", "풀무원", "식품"),

    # === 제약/바이오 ===
    ("celltrion.com", "셀트리온", "바이오"),
    ("hanmi.co.kr", "한미약품", "제약"),
    ("yuhan.co.kr", "유한양행", "제약"),
    ("greencross.com", "녹십자", "제약"),
    ("daewoong.co.kr", "대웅제약", "제약"),
    ("jw-group.co.kr", "JW그룹", "제약"),
    ("kolon.com", "코오롱", "화학/바이오"),
    ("sk-biopharmaceuticals.com", "SK바이오팜", "바이오"),
    ("samsungbiologics.com", "삼성바이오로직스", "바이오"),

    # === 에너지/화학 ===
    ("kogas.or.kr", "한국가스공사", "에너지"),
    ("kepco.co.kr", "한국전력공사", "에너지"),
    ("khnp.co.kr", "한국수력원자력", "에너지"),
    ("kospo.co.kr", "한국남부발전", "에너지"),
    ("komipo.co.kr", "한국중부발전", "에너지"),
    ("iwest.co.kr", "한국서부발전", "에너지"),
    ("kewp.co.kr", "한국동서발전", "에너지"),

    # === 공기업/공공기관 ===
    ("kotra.or.kr", "KOTRA", "공공기관"),
    ("korail.com", "코레일", "공공기관"),
    ("lh.or.kr", "LH공사", "공공기관"),
    ("nps.or.kr", "국민연금공단", "공공기관"),
    ("nhis.or.kr", "국민건강보험공단", "공공기관"),
    ("kwater.or.kr", "한국수자원공사", "공공기관"),
    ("koreapost.go.kr", "우정사업본부", "공공기관"),
]


def is_personal_email(email: str) -> bool:
    """개인 이메일인지 확인"""
    domain = email.lower().split("@")[-1]
    return domain in PERSONAL_EMAIL_BLACKLIST


def get_company_info(domain: str) -> tuple[str, str] | None:
    """
    화이트리스트에서 회사 정보 조회
    Returns: (company_name, industry) or None
    """
    domain = domain.lower()
    for d, name, industry in KOREAN_COMPANY_WHITELIST:
        if d == domain:
            return (name, industry)
    return None


def is_whitelisted_domain(domain: str) -> bool:
    """화이트리스트 도메인인지 확인"""
    return get_company_info(domain) is not None
