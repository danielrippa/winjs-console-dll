unit ChakraConsoleUtils;

{$mode delphi}

interface

  uses
    ChakraTypes, WinconTypes;

  function ScreenAreaSizeAsJsSize(aSize: TScreenAreaSize): TJsValue;
  function ScreenAreaAsJsArea(aArea: TScreenArea): TJsValue;
  function ScreenCellLocationAsJsLocation(aLocation: TScreenCellLocation): TJsValue;
  function ColorAsJsColor(aColor: TColor): TJsValue;

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


end.