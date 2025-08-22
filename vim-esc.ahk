$Esc::
{
    ret := IME_CHECK("A")
    if ret != 0           ; 1 means IME is in Hangul(Korean) mode now.
    {
        IME_SET(0)        ;한글인 경우 강제로 영문 모드로 설정
    }
    else if ret = 0       ; 0 means IME is in English mode now.
    {
        Send("{Esc}")     ;영문인 경우 Esc키만 입력한다.
    }
}

/*
  IME check
*/
IME_CHECK(WinTitle) {
    hWnd := WinGetID(WinTitle)
    return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd), 0x005, "")
}

/*
  IME set (0: English, 1: Korean)
*/
IME_SET(state) {
    hWnd := WinGetID("A")
    return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd), 0x006, state)
}

Send_ImeControl(DefaultIMEWnd, wParam, lParam) {
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows(true)
    result := SendMessage(0x283, wParam, lParam, , "ahk_id " . DefaultIMEWnd)
    if (DetectSave != A_DetectHiddenWindows)
        DetectHiddenWindows(DetectSave)
    return result
}

ImmGetDefaultIMEWnd(hWnd) {
    return DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
}