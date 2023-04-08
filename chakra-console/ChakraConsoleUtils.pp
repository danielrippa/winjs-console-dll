unit ChakraConsoleUtils;

{$mode delphi}

interface

  uses
    ChakraTypes, WinconTypes;

  function ScreenAreaSizeAsJsSize(aSize: TScreenAreaSize): TJsValue;
  function ScreenAreaAsJsArea(aArea: TScreenArea): TJsValue;
  function ScreenCellLocationAsJsLocation(aLocation: TScreenCellLocation): TJsValue;
  function ColorAsJsColor(aColor: TColor): TJsValue;

  function GetKeyName(aKeyCode: Integer): String;

implementation

  uses
    Chakra, ChakraUtils;

  function ScreenAreaSizeAsJsSize;
  begin
    Result := CreateObject;
    with aSize do begin
      SetProperty(Result, 'height', IntAsJsNumber(Height));
      SetProperty(Result, 'width', IntAsJsNumber(Width));
    end;
  end;

  function AreaSizeAsJsSize(aSize: TScreenAreaSize): TJsValue;
  begin
    Result := CreateObject;
    with aSize do begin
      SetProperty(Result, 'height', IntAsJsNumber(Height));
      SetProperty(Result, 'width', IntAsJsNumber(Width));
    end;
  end;

  function ScreenCellLocationAsJsLocation;
  begin
    Result := CreateObject;
    with aLocation do begin
      SetProperty(Result, 'row', IntAsJsNumber(Row));
      SetProperty(Result, 'column', IntAsJsNumber(Column));
    end;
  end;

  function ScreenAreaAsJsArea;
  begin
    Result := CreateObject;
    with aArea do begin
      SetProperty(Result, 'size', ScreenAreaSizeAsJsSize(Size));
      SetProperty(Result, 'location', ScreenCellLocationAsJsLocation(Location));
    end;
  end;

  function ColorAsJsColor;
  begin
    Result := CreateObject;

    SetProperty(Result, 'r', IntAsJsNumber(aColor.R));
    SetProperty(Result, 'g', IntAsJsNumber(aColor.G));
    SetProperty(Result, 'b', IntAsJsNumber(aColor.B));
  end;

  function GetKeyName;
  begin
    case aKeyCode of

      $03: Result := 'CtrlBreak';
      $08: Result := 'BackSpace';
      $09: Result := 'Tab';
      $0c: Result := 'Clear';
      $0d: Result := 'Enter';
      $10: Result := 'Shift';
      $11: Result := 'Control';
      $12: Result := 'Alt';
      $13: Result := 'Pause';
      $14: Result := 'CapsLock';

      $15: Result := 'KanaMode';
      $16: Result := 'IMEOn';
      $17: Result := 'KanjiMode';
      $1a: Result := 'IMEOff';

      $1b: Result := 'Esc';

      $1c: Result := 'IMEConvert';
      $1d: Result := 'IMENonConvert';
      $1e: Result := 'IMEAccept';
      $1f: Result := 'IMEModeChange';

      $20: Result := 'Space';
      $21: Result := 'PageUp';
      $22: Result := 'PageDown';
      $23: Result := 'End';
      $24: Result := 'Home';

      $25: Result := 'LeftArrow';
      $26: Result := 'UpArrow';
      $27: Result := 'RightArrow';
      $28: Result := 'DownArrow';

      $29: Result := 'Select';
      $2a: Result := 'Print';
      $2b: Result := 'Execute';
      $2c: Result := 'PrintScreen';
      $2d: Result := 'Insert';
      $2e: Result := 'Delete';
      $2f: Result := 'Help';

      $30: Result := '0';
      $31: Result := '1';
      $32: Result := '2';
      $33: Result := '3';
      $34: Result := '4';
      $35: Result := '5';
      $36: Result := '6';
      $37: Result := '7';
      $38: Result := '8';
      $39: Result := '9';

      $41: Result := 'A';
      $42: Result := 'B';
      $43: Result := 'C';
      $44: Result := 'D';
      $45: Result := 'E';
      $46: Result := 'F';
      $47: Result := 'G';
      $48: Result := 'H';
      $49: Result := 'I';
      $4a: Result := 'J';
      $4b: Result := 'K';
      $4c: Result := 'L';
      $4d: Result := 'M';
      $4e: Result := 'N';
      $4f: Result := 'O';
      $50: Result := 'P';
      $51: Result := 'Q';
      $52: Result := 'R';
      $53: Result := 'S';
      $54: Result := 'T';
      $55: Result := 'U';
      $56: Result := 'V';
      $57: Result := 'W';
      $58: Result := 'X';
      $59: Result := 'Y';
      $5a: Result := 'Z';

      $5b: Result := 'LeftWindows';
      $5c: Result := 'RightWindows';
      $5d: Result := 'Applications';
      $5f: Result := 'Sleep';

      $60: Result := 'Keypad0';
      $61: Result := 'Keypad1';
      $62: Result := 'Keypad2';
      $63: Result := 'Keypad3';
      $64: Result := 'Keypad4';
      $65: Result := 'Keypad5';
      $66: Result := 'Keypad6';
      $67: Result := 'Keypad7';
      $68: Result := 'Keypad8';
      $69: Result := 'Keypad9';

      $6a: Result := 'Multiply';
      $6b: Result := 'Add';
      $6c: Result := 'Separator';
      $6d: Result := 'Substract';
      $6e: Result := 'Decimal';
      $6f: Result := 'Divide';

      $70: Result := 'F1';
      $71: Result := 'F2';
      $72: Result := 'F3';
      $73: Result := 'F4';
      $74: Result := 'F5';
      $75: Result := 'F6';
      $76: Result := 'F7';
      $77: Result := 'F8';
      $78: Result := 'F9';
      $79: Result := 'F10';
      $7a: Result := 'F11';
      $7b: Result := 'F12';
      $7c: Result := 'F13';
      $7d: Result := 'F14';
      $7e: Result := 'F15';
      $7f: Result := 'F16';
      $80: Result := 'F17';
      $81: Result := 'F18';
      $82: Result := 'F19';
      $83: Result := 'F20';
      $84: Result := 'F21';
      $85: Result := 'F22';
      $86: Result := 'F23';
      $87: Result := 'F24';

      $90: Result := 'NumLock';
      $91: Result := 'ScrollLock';

      $a0: Result := 'LeftShift';
      $a1: Result := 'RightShift';
      $a2: Result := 'LeftControl';
      $a3: Result := 'RightControl';
      $a4: Result := 'LeftAlt';
      $a5: Result := 'RightAlt';

      $a6: Result := 'BrowserBack';
      $a7: Result := 'BrowserForward';
      $a8: Result := 'BrowserRefresh';
      $a9: Result := 'BrowserStop';
      $aa: Result := 'BrowserSearch';
      $ab: Result := 'BrowserFavorites';
      $ac: Result := 'BrowserHome';

      $ad: Result := 'VolumeMute';
      $ae: Result := 'VolumeDown';
      $af: Result := 'VolumeUp';

      $b0: Result := 'NextTrack';
      $b1: Result := 'PreviousTrack';

      $b2: Result := 'StopMedia';
      $b3: Result := 'PlayPauseMedia';

      $b4: Result := 'StartMail';
      $b5: Result := 'LaunchMediaSelect';

      $b6: Result := 'StartApplication1';
      $b7: Result := 'StartApplication2';

      $bb: Result := 'Plus';
      $bc: Result := 'Comma';
      $bd: Result := 'Minus';
      $be: Result := 'Period';

      $db: Result := 'OEM4';
      $dc: Result := 'OEM5';
      $dd: Result := 'OEM6';
      $de: Result := 'OEM7';
      $df: Result := 'OEM8';

      $e2: Result := 'OEM102';

      $f6: Result := 'Attn';
      $f7: Result := 'CrSel';
      $f9: Result := 'EraseEOF';
      $fa: Result := 'Play';
      $fb: Result := 'Zoom';
      $fd: Result := 'PA1';
      $fe: Result := 'Clear';

      else
        Result := 'Undefined';

    end;
  end;

end.