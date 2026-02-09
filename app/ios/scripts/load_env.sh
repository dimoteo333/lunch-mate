#!/bin/bash

# Load .env file and inject values into Info.plist
ENV_FILE="../../.env"
INFO_PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

if [ -f "$ENV_FILE" ]; then
    # Read KAKAO_NATIVE_APP_KEY from .env
    KAKAO_KEY=$(grep "^KAKAO_NATIVE_APP_KEY=" "$ENV_FILE" | cut -d '=' -f2)

    if [ -n "$KAKAO_KEY" ]; then
        # Inject into Info.plist
        /usr/libexec/PlistBuddy -c "Set :KAKAO_APP_KEY $KAKAO_KEY" "$INFO_PLIST" 2>/dev/null || \
        /usr/libexec/PlistBuddy -c "Add :KAKAO_APP_KEY string $KAKAO_KEY" "$INFO_PLIST"
    fi
fi
