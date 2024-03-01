unit ChakraConsoleWindow;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetChakraConsoleWindow: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, WinconConsoleWindow, Windows, ChakraErr;

  function GetTitle(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := StringAsJsString(ConsoleWindow.Title);
  end;

  function SetTitle(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setTitle', Args, ArgCount, [JsString], 1);
    ConsoleWindow.Title := JsStringAsString(Args^);
    Result := Undefined;
  end;

  function GetFullScreen(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleWindow.FullScreen);
  end;

  function SetFullScreen(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setFullScreen', Args, ArgCount, [JsBoolean], 1);
    ConsoleWindow.FullScreen := JsBooleanAsBoolean(Args^);
    Result := Undefined;
  end;

  function GetInputCodePage(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := IntAsJsNumber(GetConsoleCP);
  end;

  function SetInputCodePage(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setInputCodePage', Args, ArgCount, [JsNumber], 1);
    SetConsoleCP(JsNumberAsInt(Args^));
  end;

  function GetOutputCodePage(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := IntAsJsNumber(GetConsoleOutputCP);
  end;

  function SetOutputCodePage(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    CheckParams('setOutputCodePage', Args, ArgCount, [JsNumber], 1);
    SetConsoleOutputCP(JsNumberAsInt(Args^));
  end;

  function GetQuickEditState(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := BooleanAsJsBoolean(ConsoleWindow.QuickEditEnabled);
  end;

  function SetQuickEditState(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Enabled: Boolean;
  begin
    CheckParams('setOutputCodePage', Args, ArgCount, [JsBoolean], 1);
    Enabled := JsBooleanAsBoolean(Args^);
    ConsoleWindow.QuickEditEnabled := Enabled;
  end;

  function GetChakraConsoleWindow: TJsValue;
  begin
    Result := CreateObject;

    SetFunction(Result, 'getTitle', GetTitle);
    SetFunction(Result, 'setTitle', SetTitle);

    SetFunction(Result, 'getFullScreen', GetFullScreen);
    SetFunction(Result, 'setFullScreen', SetFullScreen);

    SetFunction(Result, 'getInputCodePage', GetInputCodePage);
    SetFunction(Result, 'setInputCodePage', SetInputCodePage);

    SetFunction(Result, 'getOutputCodePage', GetOutputCodePage);
    SetFunction(Result, 'setOutputCodePage', SetOutputCodePage);

    SetFunction(Result, 'getQuickEditState', GetQuickEditState);
    SetFunction(Result, 'setQuickEditState', SetQuickEditState);
  end;

end.