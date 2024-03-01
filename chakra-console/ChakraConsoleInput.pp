unit ChakraConsoleInput;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetChakraConsoleInput: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, WinconConsoleInput, ChakraConsoleUtils, ChakraErr;

  function GetInputEventType: TJsValue;
  var
    EventType: String;
  begin
    with ConsoleInput do begin
      case ConsoleInput.NextInputEventType of
        ietNone: EventType := 'None';

        ietWindowEvent: begin
          case NextWindowEventType of
            wetWindowFocus: EventType := 'WindowFocus';
            wetWindowResized: EventType := 'WindowResized';
          end;
        end;

        ietKeyEvent: begin
          case NextKeyEventType of
            ketPressed: EventType := 'KeyPressed';
            ketReleased: EventType := 'KeyReleased';
          end;
        end;

        ietMouseEvent: begin
          case NextMouseEventType of
            metDoubleClick: EventType := 'DoubleClick';
            metHorizontalWheel: EventType := 'HorizontalWheel';
            metMouseCursorMoved: EventType := 'MouseMoved';
            metVerticalWheel: EventType := 'VerticalWheel';
            metSingleClick: EventType := 'SingleClick';
            metButtonReleased: EventType := 'ClickReleased';
          end;
        end;
      end;
    end;

    Result := StringAsJsString(EventType);
  end;

  function DiscardInputEvent: TJsValue;
  begin
    Result := Undefined;
    ConsoleInput.DiscardNextEvent;
  end;

  function GetWindowFocusEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietWindowEvent then begin
        if NextWindowEventType = wetWindowFocus then begin

          Result := CreateObject;

          with WindowFocusEvent do begin
            SetProperty(Result, 'focused', BooleanAsJsBoolean(Focused));
          end;

        end;
      end;
    end;
  end;

  function GetWindowResizedEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietWindowEvent then begin
        if NextWindowEventType = wetWindowResized then begin

          Result := CreateObject;

          with WindowResizedEvent do begin
            SetProperty(Result, 'rows', IntAsJsNumber(Rows));
            SetProperty(Result, 'columns', IntAsJsNumber(Columns));
          end;

        end;
      end;
    end;
  end;

  procedure SetControlKeys(KeyEvent: TJsValue; ControlKeys: TControlKeys);
  begin
    with ControlKeys do begin
      SetProperty(KeyEvent, 'capsLock', BooleanAsJsBoolean(CapslockOn));
      SetProperty(KeyEvent, 'enhancedKey', BooleanAsJsBoolean(EnhancedKey));
      SetProperty(KeyEvent, 'leftAlt', BooleanAsJsBoolean(LeftAltPressed));
      SetProperty(KeyEvent, 'leftCtrl', BooleanAsJsBoolean(LeftCtrlPressed));
      SetProperty(KeyEvent, 'numLock', BooleanAsJsBoolean(NumLockOn));
      SetProperty(KeyEvent, 'rightAlt', BooleanAsJsBoolean(RightAltPressed));
      SetProperty(KeyEvent, 'rightCtrl', BooleanAsJsBoolean(RightCtrlPressed));
      SetProperty(KeyEvent, 'scrollLock', BooleanAsJsBoolean(ScrollLockOn));

      SetProperty(KeyEvent, 'shift', BooleanAsJsBoolean(ShiftPressed));
      SetProperty(KeyEvent, 'alt', BooleanAsJsBoolean(LeftAltPressed or RightAltPressed));
      SetProperty(KeyEvent, 'ctrl', BooleanAsJsBoolean(LeftCtrlPressed or RightCtrlPressed));
    end;
  end;

  function GetKeyType(KeyCode: Integer): String;
  begin

    Result := 'none';

    case KeyCode of
      $20: Result := 'alphabetic';
      $09: Result := 'navigation';
      $08, $2E, $2D: Result := 'edition';

      else begin

        if (KeyCode >= $21) and (KeyCode <= $28) then begin
          Result := 'navigation'; Exit;
        end;
        if (KeyCode >= $41) and (KeyCode <= $5A) then begin
          Result := 'alphabetic'; Exit;
        end;
        if (KeyCode >= $BB) and (KeyCode <= $BE) then begin
          Result := 'punctuation'; Exit;
        end;
        if (KeyCode >= $30) and (KeyCode <= $39) then begin
          Result := 'numeric'; Exit;
        end;
        if (KeyCode >= $70) and (KeyCode <= $87) then begin
          Result := 'function'; Exit;
        end;
        if (KeyCode >= $AD) and (KeyCode <= $B3) then begin
          Result := 'media'; Exit;
        end;

      end;
    end;
  end;

  function GetKeyPressedEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietKeyEvent then begin
        if NextKeyEventType = ketPressed then begin

          Result := CreateObject;

          with KeyPressedEvent do begin
            SetProperty(Result, 'scanCode', IntAsJsNumber(ScanCode));
            SetProperty(Result, 'keyCode', IntAsJsNumber(KeyCode));
            SetProperty(Result, 'character', StringAsJsString(UnicodeChar));
            SetProperty(Result, 'keyType', StringAsJsString(GetKeyType(KeyCode)));
            SetProperty(Result, 'repetitions', IntAsJsNUmber(Repetitions));
            SetProperty(Result, 'name', StringAsJsString(GetKeyName(KeyCode)));

            SetControlKeys(Result, ControlKeys);
          end;

        end;
      end;
    end;
  end;

  function GetKeyReleasedEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietKeyEvent then begin
        if NextKeyEventType = ketReleased then begin

          Result := CreateObject;

          with KeyReleasedEvent do begin
            SetProperty(Result, 'scanCode', IntAsJsNumber(ScanCode));
            SetProperty(Result, 'keyCode', IntAsJsNumber(KeyCode));
            SetProperty(Result, 'character', StringAsJsString(UnicodeChar));
            SetProperty(Result, 'name', StringAsJsString(GetKeyName(KeyCode)));

            SetControlKeys(Result, ControlKeys);
          end;

        end;
      end;
    end;
  end;

  procedure SetCursorLocation(Instance: TJsValue; Row, Column: Integer);
  begin
    SetProperty(Instance, 'row', IntAsJsNumber(Row));
    SetProperty(Instance, 'column', IntAsJsNumber(Column));
  end;

  function GetMouseMovedEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietMouseEvent then begin
        if NextMouseEventType = metMouseCursorMoved then begin

          Result := CreateObject;

          with MouseCursorMovedEvent.CursorLocation do begin
            SetCursorLocation(Result, Row, Column);
          end;

        end;
      end;
    end;
  end;

  function GetMouseClickEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietMouseEvent then begin
        if (NextMouseEventType = metSingleClick) or (NextMouseEventType = metDoubleClick) then begin

          Result := CreateObject;

          with MouseButtonClickedEvent do begin

            with CursorLocation do begin
              SetCursorLocation(Result, Row, Column);
            end;

            with Buttons do begin
              SetProperty(Result, 'left1', BooleanAsJsBoolean(Left1Pressed));
              SetProperty(Result, 'left2', BooleanAsJsBoolean(Left2Pressed));
              SetProperty(Result, 'left3', BooleanAsJsBoolean(Left3Pressed));
              SetProperty(Result, 'left4', BooleanAsJsBoolean(Left4Pressed));

              SetProperty(Result, 'rightMost', BooleanAsJsBoolean(RightMostPressed));
            end;

          end;

        end;
      end;
    end;
  end;

  function GetSingleClickEvent: TJsValue;
  begin
    Result := GetMouseClickEvent;
  end;

  function GetDoubleClickEvent: TJsValue;
  begin
    Result := GetMouseClickEvent;
  end;

  function GetClickReleasedEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietMouseEvent then begin
        if NextMouseEventType = metButtonReleased then begin

          Result := CreateObject;

          with MouseButtonReleasedEvent do begin

            with CursorLocation do begin
              SetCursorLocation(Result, Row, Column);
            end;

          end;

        end;
      end;
    end;
  end;

  function GetVerticalWheelEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietMouseEvent then begin
        if NextMouseEventType = metVerticalWheel then begin

          Result := CreateObject;

          with MouseVerticalWheelEvent do begin

            with CursorLocation do begin
              SetCursorLocation(Result, Row, Column);
            end;

            case WheelDirection of
              mvwdForward: SetProperty(Result, 'direction', StringAsJsString('forward'));
              mvwdBackwards: SetProperty(Result, 'direction', StringAsJsString('backwards'));
            end;
          end;

        end;
      end;
    end;
  end;

  function GetHorizontalWheelEvent: TJsValue;
  begin
    Result := Undefined;

    with ConsoleInput do begin
      if NextInputEventType = ietMouseEvent then begin
        if NextMouseEventType = metHorizontalWheel then begin

          Result := CreateObject;

          with MouseHorizontalWheelEvent do begin

            with CursorLocation do begin
              SetCursorLocation(Result, Row, Column);
            end;

            case WheelDirection of
              mhwdRight: SetProperty(Result, 'direction', StringAsJsString('left'));
              mhwdLeft: SetProperty(Result, 'direction', StringAsJsString('right'));


            end;
          end;
        end;
      end;
    end;
  end;

  function IsQuickEditModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.QuickEditModeEnabled);
  end;

  function SetQuickEditMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setQuickEditMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.QuickEditModeEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsEchoInputModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.EchoInputEnabled);
  end;

  function SetEchoInputMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setEchoInputMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.EchoInputEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsInsertModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.InsertModeEnabled);
  end;

  function SetInsertMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setInsertMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.InsertModeEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsLineInputModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.LineInputEnabled);
  end;

  function SetLineInputMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setLineInputMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.LineInputEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsMouseInputModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.MouseInputEnabled);
  end;

  function SetMouseInputMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setMouseInputMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.MouseInputEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsProcessedInputModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.ProcessedInputEnabled);
  end;

  function SetProcessedInputMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setProcessedInputMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.ProcessedInputEnabled := JsBooleanAsBoolean(Args^);
  end;

  function IsWindowInputModeEnabled: TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleInput.WindowInputEnabled);
  end;

  function SetWindowInputMode(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;
    CheckParams('setWindowInputMode', Args, ArgCount, [jsBoolean], 1);

    ConsoleInput.WindowInputEnabled := JsBooleanAsBoolean(Args^);
  end;

  function GetChakraConsoleInput;
  begin
    Result := CreateObject;

    SetFunction(Result, 'isQuickEditModeEnabled', @IsQuickEditModeEnabled);
    SetFunction(Result, 'setQuickEditMode', @SetQuickEditMode);

    SetFunction(Result, 'isEchoInputEnabled', @IsEchoInputModeEnabled);
    SetFunction(Result, 'setEchoInputMode', @SetEchoInputMode);

    SetFunction(Result, 'isInsertModeEnabled', @IsInsertModeEnabled);
    SetFunction(Result, 'setInsertMode', @SetInsertMode);

    SetFunction(Result, 'isLineInputEnabled', @IsLineInputModeEnabled);
    SetFunction(Result, 'setLineInputMode', @SetLineInputMode);

    SetFunction(Result, 'isMouseInputEnabled', @IsMouseInputModeEnabled);
    SetFunction(Result, 'setMouseInputMode', @SetMouseInputMode);

    SetFunction(Result, 'isProcessedInputEnabled', @IsProcessedInputModeEnabled);
    SetFunction(Result, 'setProcessedInputMode', @SetProcessedInputMode);

    SetFunction(Result, 'isWindowInputEnabled', @IsWindowInputModeEnabled);
    SetFunction(Result, 'setWindowInputMode', @SetWindowInputMode);

    SetFunction(Result, 'getInputEventType', @GetInputEventType);
    SetFunction(Result, 'discardInputEvent', @DiscardInputEvent);

    SetFunction(Result, 'getWindowFocusEvent', @GetWindowFocusEvent);
    SetFunction(Result, 'getWindowResizedEvent', @GetWindowResizedEvent);

    SetFunction(Result, 'getKeyPressedEvent', @GetKeyPressedEvent);
    SetFunction(Result, 'getKeyReleasedEvent', @GetKeyReleasedEvent);

    SetFunction(Result, 'getMouseMovedEvent', @GetMouseMovedEvent);
    SetFunction(Result, 'getSingleClickEvent', @GetSingleClickEvent);
    SetFunction(Result, 'getDoubleClickEvent', @GetDoubleClickEvent);
    SetFunction(Result, 'getClickReleasedEvent', @GetClickReleasedEvent);

    SetFunction(Result, 'getVerticalWheelEvent', @GetVerticalWheelEvent);
    SetFunction(Result, 'getHorizontalWheelEvent', @GetHorizontalWheelEvent);
  end;

end.