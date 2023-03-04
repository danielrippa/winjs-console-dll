unit Win32GDIUtils;

{$mode delphi}

interface

  type

    TFontFaceNames = array of String;

  function GetConsoleFontFaceNames: TFontFaceNames;

implementation

  uses
    Windows;

  var FontFaceNames: TFontFaceNames;

  function EnumFontsProc(const lpelfe: TlogFont; const lpntme: TNewTextMetricExW; FontType: DWORD; param: LPARAM): Integer; stdcall;
  var
    L: Integer;
  begin
    if (lpelfe.lfPitchAndFamily and $03) = FIXED_PITCH then begin
      if (lpelfe.lfPitchAndFamily and $F0) = FF_MODERN then begin
        L := Length(FontFaceNames);
        SetLength(FontFaceNames, L + 1);
        FontFaceNames[L] := lpelfe.lfFaceName;
      end;
    end;

    Result := 1;
  end;

  function GetConsoleFontFaceNames: TFontFaceNames;
  var
    DC: hDC;
    ConsoleWindow: Handle;
  begin
    SetLength(FontFaceNames, 0);
    ConsoleWindow := Windows.GetConsoleWindow;
    DC := GetWindowDC(ConsoleWindow);
    try
      EnumFonts(DC, Nil, @EnumFontsProc, Nil);
    finally
      ReleaseDC(ConsoleWindow, DC);
    end;
    Result := FontFaceNames;
  end;

end.