import re
from src.models.notification import Notification

def extract_mentions(content: str) -> list[str]:
    return re.findall(r'@([a-zA-Z0-9_가-힣]+)', content)

def test_extract_mentions_single():
    content = "Hello @JohnDoe!"
    mentions = extract_mentions(content)
    assert mentions == ['JohnDoe']

def test_extract_mentions_multiple():
    content = "Hi @alice and @bob_123"
    mentions = extract_mentions(content)
    assert mentions == ['alice', 'bob_123']

def test_extract_mentions_korean():
    content = "안녕 @홍길동 내일 점심 어때?"
    mentions = extract_mentions(content)
    assert mentions == ['홍길동']

def test_extract_mentions_no_mentions():
    content = "Just a regular test message without tags."
    mentions = extract_mentions(content)
    assert mentions == []

def test_notification_model_creation():
    notif = Notification(
        user_id="user_1",
        sender_id="sender_1",
        type="mention",
        content="홍길동님이 회원님을 언급했습니다.",
        reference_id="room_1"
    )
    assert notif.user_id == "user_1"
    assert notif.sender_id == "sender_1"
    assert notif.type == "mention"
    assert notif.content == "홍길동님이 회원님을 언급했습니다."
    assert notif.reference_id == "room_1"
    assert notif.is_read in (False, None) # default value is False, but may be None before DB flush
