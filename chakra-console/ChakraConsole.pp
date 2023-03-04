unit ChakraConsole;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses
    Chakra, Windows, ChakraConsoleWindow, ChakraConsoleInput, ChakraConsoleScreenBuffer, Win32GDIUtils;

  function GetConsoleFontFaces(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Names: TFontFaceNames;
    L, I: Integer;
  begin
    Names := GetConsoleFontFaceNames;
    L := Length(Names);

    Result := CreateArray(L);

    for I := 0 to L - 1 do begin
      SetArrayItem(Result, I, StringAsJsString(Names[I]));
    end;
  end;

  function GetJsValue;
  begin
    Result := CreateObject;

    SetProperty(Result, 'window', GetChakraConsoleWindow);
    SetProperty(Result, 'input', GetChakraConsoleInput);
    SetProperty(Result, 'screenBuffer', GetChakraConsoleScreenBuffer);

    SetFunction(Result, 'getFontFaces', GetConsoleFontFaces);
  end;

end.