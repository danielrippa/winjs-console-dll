unit ChakraConsoleScreenBuffer;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetChakraConsoleScreenBuffer: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, Windows, WinconScreenBuffer, WinconTypes, WinconUtils, ChakraConsoleUtils;

  var Buffer: TScreenBuffer;

  procedure SetBuffer(Args: PJsValue);
  begin
    CheckParams('', Args, 1, [jsNumber], 1);
    Buffer.Init(THandle(JsNumberAsInt(Args^)));
  end;

  function NewScreenBufferHandle: TJsValue;
  begin
    Result := IntAsJsNumber(CreateScreenBuffer);
  end;

  function ActivateScreenBuffer(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    Buffer.Activate;
  end;

  function CloseScreenBuffer(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    Buffer.Close;
  end;

  function GetStdoutHandle: TJsValue;
  begin
    Result := IntAsJsNumber(GetStdHandle(STD_OUTPUT_HANDLE));
  end;

  function GetCursorLocation(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);
    Result := ScreenCellLocationAsJsLocation(Buffer.Cursor.Location);
  end;

  function SetCursorLocation(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Row, Column: Integer;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setCursorLocation', Args, ArgCount, [jsNumber, jsNumber, jsNumber], 3); Inc(Args);

    Row := JsNumberAsInt(Args^); Inc(Args);
    Column := JsNumberAsInt(Args^);

    Buffer.Cursor.Location := ScreenCellLocation(Row, Column);
  end;

  function GetCursorVisibility(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);
    Result := BooleanAsJsBoolean(Buffer.Cursor.Visible);
  end;

  function SetCursorVisibility(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Visible: Boolean;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setCursorVisibility', Args, ArgCount, [jsNumber, jsBoolean], 2); Inc(Args);

    Visible := JsBooleanAsBoolean(Args^);

    Buffer.Cursor.Visible := Visible;
  end;

  function GetCursorSize(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);
    Result := IntAsJsNumber(Buffer.Cursor.Size);
  end;

  function SetCursorSize(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Size: Integer;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setCursorSize', Args, ArgCount, [jsNumber, jsNumber], 2); Inc(Args);

    Size := JsNumberAsInt(Args^);

    Buffer.Cursor.Size := Size;
  end;

  function IsVirtualTerminalProcessingEnabled(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);

    Result := BooleanAsJsBoolean(Buffer.VirtualTerminalProcessingEnabled);
  end;

  function SetVirtualTerminalProcessingState(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);

    CheckParams('setVirtualTerminalProcessingState', Args, ArgCount, [jsNumber, jsBoolean], 2); Inc(Args);

    Buffer.VirtualTerminalProcessingEnabled := JsBooleanAsBoolean(Args^);
  end;


  function AreExtendedAttributesEnabled(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);

    Result := BooleanAsJsBoolean(Buffer.ExtendedCharacterAttributesEnabled);
  end;

  function SetExtendedAttributesState(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setExtendedAttributesState', Args, ArgCount, [jsNumber, jsBoolean], 2); Inc(Args);

    Buffer.ExtendedCharacterAttributesEnabled := JsBooleanAsBoolean(Args^);
  end;

  function GetTextAttributesValue(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);
    Result := IntAsJsNumber(Buffer.TextAttributes);
  end;

  function SetTextAttributesValue(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setTextAttributesValue', Args, ArgCount, [jsNumber, jsNumber], 2); Inc(Args);

    Buffer.TextAttributes := JsNumberAsInt(Args^);
  end;

  function GetPaletteColor(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    ColorIndex: Integer;
  begin
    SetBuffer(Args);
    CheckParams('getPaletteColor', Args, ArgCount, [jsNumber, jsNumber], 2); Inc(Args);

    ColorIndex := JsNumberAsInt(Args^);
    Result := ColorAsJsColor(Buffer.PaletteColor[ColorIndex]);
  end;

  function SetPaletteColor(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    ColorIndex: Integer;
    R, G, B: Integer;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setPaletteColor', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber], 5); Inc(Args);

    ColorIndex := JsNumberAsInt(Args^); Inc(Args);

    R := JsNumberAsInt(Args^); Inc(Args);
    G := JsNumberAsInt(Args^); Inc(Args);
    B := JsNumberAsInt(Args^);

    Buffer.PaletteColor[ColorIndex] := Color(R, G, B);
  end;

  function GetFontFace(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    SetBuffer(Args);
    Result := StringAsJsString(Buffer.FontFace);
  end;

  function SetFontFace(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('setFontFace', Args, ArgCount, [jsNumber, jsString], 2); Inc(Args);

    Buffer.FontFace := JsStringAsString(Args^);
  end;

  function WriteBuffer(Args: PJsValue; ArgCount: Word): TJsValue;
  begin
    Result := Undefined;

    SetBuffer(Args);
    CheckParams('write', Args, ArgCount, [jsNumber, jsString], 2); Inc(Args);

    Buffer.Write(JsStringAsString(Args^));
  end;

  var BufferArea: TScreenArea;

  procedure SetBufferArea(var Args: PJsValue);
  begin
    with BufferArea do begin
      with Location do begin
        Row := JsNumberAsInt(Args^); Inc(Args);
        Column := JsNumberAsInt(Args^); Inc(Args);
      end;

      with Size do begin
        Height := JsNumberAsInt(Args^); Inc(Args);
        Width := JsNumberAsInt(Args^); Inc(Args);
      end;
    end;
  end;

  function GetAreaCharacters(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aLength: Integer;
    AreaLength: Integer;
    AreaCharacters: WideString;
    Characters: WideString;
    I: Integer;
  begin
    SetBuffer(Args);
    CheckParams('getAreaCharacters', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsNumber], 5); Inc(Args);
    SetBufferArea(Args);

    with BufferArea.Size do begin
      AreaLength := Height * Width;
    end;

    aLength := -1;

    if ArgCount > 5 then begin
      aLength := JsNumberAsInt(Args^);
    end;

    if (aLength = -1) or (AreaLength > aLength) then begin
      aLength := AreaLength;
    end;

    Result := StringAsJsString(Buffer.GetAreaCharacters(BufferArea));
  end;

  function SetAreaCharacters(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Characters: WideString;
  begin
    Result := Undefined;
    SetBuffer(Args);

    CheckParams('setAreaCharacters', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsString], 6); Inc(Args);
    SetBufferArea(Args);

    Characters := JsStringAsString(Args^);

    Buffer.SetAreaCharacters(BufferArea, Characters);
  end;

  function GetAreaAttributes(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    AttributeValues: TScreenCellsAttributes;
    AttributesCount: Integer;
    I: Integer;
  begin
    SetBuffer(Args);

    CheckParams('setAreaAttributes', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber], 5); Inc(Args);
    SetBufferArea(Args);

    AttributeValues := Buffer.GetAreaAttributes(BufferArea);

    AttributesCount := Length(AttributeValues);

    Result := CreateArray(AttributesCount);

    for I := 0 to AttributesCount -1 do begin
      SetArrayItem(Result, I, IntAsJsNumber(AttributeValues[I]));
    end;
  end;

  function SetAreaAttributes(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    AttributesArray: TJsValue;

    ArrayLength: Integer;
    AttributeValue: Integer;
    I: Integer;
    AreaSize: Integer;
    AttributesCount: Integer;
    AttributeValues: TScreenCellsAttributes;
  begin
    Result := Undefined;

    SetBuffer(Args);

    CheckParams('setAreaAttributes', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsArray], 7); Inc(Args);
    SetBufferArea(Args);

    with BufferArea.Size do begin
      AreaSize := Height * Width;
    end;

    AttributesArray := TJsValue(Args^);
    AttributesCount := GetIntProperty(AttributesArray, 'length');

    if AttributesCount > AreaSize then begin
      AttributesCount := AreaSize;
    end;

    SetLength(AttributeValues, AttributesCount);

    for I := 0 to AttributesCount - 1 do begin
      AttributeValue := JsNumberAsInt(GetArrayItem(AttributesArray, I));
      AttributeValues[I] := AttributeValue;
    end;

    Buffer.SetAreaAttributes(BufferArea, AttributeValues);
  end;

  function SetAreaAttributesValue(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    AttributeValue: Word;
    Attributes: TScreenCellsAttributes;
    aLength: Integer;
    I: Integer;
  begin

    // TODO: remimplement using FillConsoleOutputAttribute

    Result := Undefined;
    SetBuffer(Args);

    CheckParams('setAreaAttributesValue', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsNumber], 7); Inc(Args);
    SetBufferArea(Args);

    AttributeValue := JsNumberAsInt(Args^); Inc(Args);
    aLength := JsNumberAsInt(Args^);

    if aLength = -1 then begin
      with BufferArea.Size do begin
        aLength := Height * Width;
      end;
    end;

    SetLength(Attributes, aLength);

    Attributes := Buffer.GetAreaAttributes(BufferArea);

    for I := 0 to aLength - 1 do begin
      Attributes[I] := AttributeValue;
    end;

    Buffer.SetAreaAttributes(BufferArea, Attributes);
  end;

  function SetAreaCharacter(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    Character: WideString;
    Characters: WideString;
    aLength: Integer;
    I: Integer;
  begin

    // TODO: reimplement using FillConsoleOutputCharacter

    Result := Undefined;
    SetBuffer(Args);

    CheckParams('setAreaCharacter', Args, ArgCount, [jsNumber, jsNumber, jsNumber, jsNumber, jsNumber, jsString, jsNumber], 7); Inc(Args);
    SetBufferArea(Args);

    Character := JsStringAsString(Args^); Inc(Args);

    aLength := JsNumberAsInt(Args^);

    if aLength = -1 then begin
      with BufferArea.Size do begin
        aLength := Height * Width;
      end;
    end;

    Characters := '';

    for I := 0 to aLength - 1 do begin
      Characters := Characters + Character;
    end;

    Buffer.SetAreaCharacters(BufferArea, Characters);
  end;

  function GetChakraConsoleScreenBuffer;
  begin
    Result := CreateObject;

    SetFunction(Result, 'newScreenBufferHandle', @NewScreenBufferHandle);
    SetFunction(Result, 'activateScreenBuffer', @ActivateScreenBuffer);
    SetFunction(Result, 'closeScreenBuffer', @CloseScreenBuffer);

    SetFunction(Result, 'getStdoutHandle', @GetStdoutHandle);

    SetFunction(Result, 'getCursorLocation', @GetCursorLocation);
    SetFunction(Result, 'setCursorLocation', @SetCursorLocation);
    SetFunction(Result, 'getCursorVisibility', @GetCursorVisibility);
    SetFunction(Result, 'setCursorVisibility', @SetCursorVisibility);
    SetFunction(Result, 'getCursorSize', @GetCursorSize);
    SetFunction(Result, 'setCursorSize', @SetCursorSize);

    SetFunction(Result, 'isVirtualTerminalProcessingEnabled', @IsVirtualTerminalProcessingEnabled);
    SetFunction(Result, 'setVirtualTerminalProcessingState', @SetVirtualTerminalProcessingState);

    SetFunction(Result, 'areExtendedAttributesEnabled', @AreExtendedAttributesEnabled);
    SetFunction(Result, 'setExtendedAttributesState', @SetExtendedAttributesState);

    SetFunction(Result, 'getTextAttributesValue', @GetTextAttributesValue);
    SetFunction(Result, 'setTextAttributesValue', @SetTextAttributesValue);

    SetFunction(Result, 'getPaletteColor', @GetPaletteColor);
    SetFunction(Result, 'setPaletteColor', @SetPaletteColor);

    SetFunction(Result, 'getFontFace', @GetFontFace);
    SetFunction(Result, 'setFontFace', @SetFontFace);

    SetFunction(Result, 'getAreaAttributes', @GetAreaAttributes);
    SetFunction(Result, 'setAreaAttributes', @SetAreaAttributes);
    SetFunction(Result, 'getAreaCharacters', @GetAreaCharacters);
    SetFunction(Result, 'setAreaCharacters', @SetAreaCharacters);

    SetFunction(Result, 'setAreaAttributesValue', @SetAreaAttributesValue);
    SetFunction(Result, 'setAreaCharacter', @SetAreaCharacter);

    SetFunction(Result, 'write', @WriteBuffer);
  end;

end.