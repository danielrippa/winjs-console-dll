unit ChakraConsoleInput;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetChakraConsoleInput: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, WinconConsoleInput;

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

  function GetKeyType(KeyCode: Integer): String;
  begin

    Result := 'none';

    case KeyCode of
      $09: Result := 'navigation';
      $08, $2E, $2D: Result := 'edition';

      else begin

        if (KeyCode >= $21) and (KeyCode <= $28) then Result := 'navigation'; Exit;
        if (KeyCode >= $41) and (KeyCode <= $5A) then Result := 'alphabetic'; Exit;
        if (KeyCode >= $BB) and (KeyCode <= $BE) then Result := 'punctuation'; Exit;
        if (KeyCode >= $30) and (KeyCode <= $39) then Result := 'numeric'; Exit;
        if (KeyCode >= $70) and (KeyCode <= $87) then Result := 'function'; Exit;
        if (KeyCode >= $AD) and (KeyCode <= $B3) then Result := 'media'; Exit;

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
            SetProperty(Result, 'keyType', StringAsJsString(GetKeyType(KeyCode)));
            SetProperty(Result, 'repetitions', IntAsJsNUmber(Repetitions));
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

  function GetChakraConsoleInput;
  begin
    Result := CreateObject;

    SetFunction(Result, 'isQuickEditModeEnabled', @IsQuickEditModeEnabled);
    SetFunction(Result, 'setQuickEditMode', @SetQuickEditMode);

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