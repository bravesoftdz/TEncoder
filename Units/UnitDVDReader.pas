{ *
  * Copyright (C) 2011-2015 ozok <ozok26@gmail.com>
  *
  * This file is part of TEncoder.
  *
  * TEncoder is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * TEncoder is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with TEncoder.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }
unit UnitDVDReader;

interface

uses Classes, Windows, SysUtils, JvCreateProcess, Messages, StrUtils, Generics.Collections, dialogs;

type
  TStatus = (fsReading, fsDone);

type
  TAudioStream = record
    Name: string;
    ID: string;
  end;

type
  TSubtitleStream = record
    Name: string;
    ID: string;
  end;

type
  TTitle = class(TObject)
  private
    function GetDurationInt: integer;
    function GetFormattedDur: string;
  public
    AudioStreams: TList<TAudioStream>;
    SubtitleStreams: TList<TSubtitleStream>;
    Chapters: TStringList;
    ChapterDurations: TList<Integer>;
    DurationStr: string;
    property DurationFormatedStr: string read GetFormattedDur;
    property DurationInt: integer read GetDurationInt;
    constructor Create;
    destructor Destroy; override;
  end;

type
  TDVDTitleCountExtractor = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FStatus: TStatus;
    FTitleCount: Integer;
    FMPlayerPath: string;
    FDVDFolder: string;

    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
  public
    property Status: TStatus read FStatus;
    property TitleCount: Integer read FTitleCount;

    constructor Create(const DVDFolder: string; const MplayerPath: string);
    destructor Destroy(); override;
    procedure Start();
  end;

type
  TDVDTitleInfoExtractor = class(TObject)
  private
    FProcess: TJvCreateProcess;
    FStatus: TStatus;
    FMPlayerPath: string;
    FDVDFolder: string;
    FTitleIndex: Integer;
    FTitle: TTitle;

    procedure ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    function TimeToInt(TimeStr: string): Integer;
    function IsStringNumeric(Str: String): Boolean;
  public
    property Status: TStatus read FStatus;
    property Title: TTitle read FTitle;

    constructor Create(const DVDFolder: string; const MplayerPath: string; const TitleIndex: Integer);
    destructor Destroy(); override;
    procedure Start();
  end;

implementation

uses UnitMain;

{ TTitle }

constructor TTitle.Create;
begin
  AudioStreams := TList<TAudioStream>.Create;
  SubtitleStreams := TList<TSubtitleStream>.Create;
  Chapters := TStringList.Create;
  ChapterDurations := TList<Integer>.Create;
  DurationStr := '0';
end;

destructor TTitle.Destroy;
begin
  AudioStreams.Free;
  SubtitleStreams.Free;
  Chapters.Free;
  ChapterDurations.Free;
end;

function TTitle.GetDurationInt: integer;
var
  lTmpStr: string;
begin
  Result := 0;
  if Length(DurationStr) > 0 then
  begin
    lTmpStr := DurationStr;
    lTmpStr := StringReplace(lTmpStr, '.', '', [rfReplaceAll]);
    Result := StrToInt(lTmpStr) div 1000;
  end;
end;

function TTitle.GetFormattedDur: string;
var
  LDurStr: string;
  lDurMSInt: Integer;
  LHour: string;
  LMin: string;
  LSec: string;
  LMinSec: string;
begin
  Result := '00:00:00.000';

  LDurStr := DurationStr;
  LDurStr := StringReplace(LDurStr, '.', '', [rfReplaceAll]);
  if TryStrToInt(LDurStr, lDurMSInt) then
  begin
    LHour := FloatToStr((lDurMSInt div 1000) div 3600);
    LMin := FloatToStr(((lDurMSInt div 1000) div 60 - (((lDurMSInt div 1000) div 3600) * 60)));
    LSec := FloatToStr(lDurMSInt mod 60);
    LMinSec := FloatToStr(lDurMSInt mod 1000);
    if Length(LHour) < 2 then
    begin
      LHour := '0' + LHour;
    end;
    if Length(LMin) < 2 then
    begin
      LMin := '0' + LMin;
    end;
    if Length(LSec) < 2 then
    begin
      LSec := '0' + LSec;
    end;
    Result := LHour + ':' + LMin + ':' + LSec + '.' + LMinSec;
  end;

end;

{ TDVDTitleCountExtractor }

constructor TDVDTitleCountExtractor.Create(const DVDFolder, MplayerPath: string);
begin
  inherited Create;

  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
  begin
    OnTerminate := ProcessTerminate;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := True;
  end;

  FStatus := fsReading;
  FMPlayerPath := MplayerPath;
  FDVDFolder := DVDFolder;
end;

destructor TDVDTitleCountExtractor.Destroy;
begin
  FProcess.Free;
end;

procedure TDVDTitleCountExtractor.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
const
  TITLE_COUNT = 'ID_DVD_TITLES=';
var
  I: Integer;
  LLine: string;
  lTmpStr: string;
begin
  FStatus := fsReading;
  try
    if FProcess.ConsoleOutput.Count > 0 then
    begin
      // get dvd title count
      for I := 0 to FProcess.ConsoleOutput.Count - 1 do
      begin
        LLine := Trim(FProcess.ConsoleOutput[i]);
        if TITLE_COUNT = Copy(LLine, 1, Length(TITLE_COUNT)) then
        begin
          lTmpStr := StringReplace(LLine, TITLE_COUNT, '', [rfReplaceAll]);
          if not TryStrToInt(lTmpStr, FTitleCount) then
          begin
            FTitleCount := 0;
          end;
        end;
      end;
    end;
  finally
    FStatus := fsDone;
  end;

end;

procedure TDVDTitleCountExtractor.Start;
begin
  FProcess.ApplicationName := FMPlayerPath;
  FProcess.CommandLine := ' -msglevel identify=6 -frames 0 -vo null -quiet dvd:// -dvd-device "' + FDVDFolder + '"';
  FProcess.Run;
end;

{ TDVDTitleInfoExtractor }

constructor TDVDTitleInfoExtractor.Create(const DVDFolder, MplayerPath: string; const TitleIndex: Integer);
begin
  FProcess := TJvCreateProcess.Create(nil);
  with FProcess do
  begin
    OnTerminate := ProcessTerminate;
    ConsoleOptions := [coRedirect];
    CreationFlags := [cfUnicode];
    Priority := ppIdle;

    with StartupInfo do
    begin
      DefaultPosition := False;
      DefaultSize := False;
      DefaultWindowState := False;
      ShowWindow := swHide;
    end;

    WaitForTerminate := True;
  end;

  FStatus := fsReading;
  FMPlayerPath := MplayerPath;
  FDVDFolder := DVDFolder;
  FTitleIndex := TitleIndex;
  FTitle := TTitle.Create;
end;

destructor TDVDTitleInfoExtractor.Destroy;
begin
  inherited;
  FProcess.Free;
end;

function TDVDTitleInfoExtractor.IsStringNumeric(Str: String): Boolean;
var
  P: PChar;
begin

  if Length(Str) < 1 then
  begin
    Result := False;
    Exit;
  end;

  P := PChar(Str);
  Result := False;

  while P^ <> #0 do
  begin

    if (Not CharInSet(P^, ['0' .. '9'])) then
    begin
      Exit;
    end;

    Inc(P);
  end;

  Result := True;
end;

procedure TDVDTitleInfoExtractor.ProcessTerminate(Sender: TObject; ExitCode: Cardinal);
const
  Audio = 'audio stream';
  Subtitle = 'subtitle ( sid ):';
  Chapter = 'CHAPTERS:';
var
  LLine: string;
  i: Integer;
  LAudioStream: TAudioStream;
  LSubStream: TSubtitleStream;
  LSplitList: TStringList;
  j: Integer;
begin
  FStatus := fsReading;
  try
    // get title duration
    for I := 0 to FProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FProcess.ConsoleOutput[i]);
      if ('ID_DVD_TITLE_' + FloatToStr(FTitleIndex) + '_LENGTH=') = Copy(LLine, 1, Length('ID_DVD_TITLE_' + FloatToStr(FTitleIndex) + '_LENGTH=')) then
      begin
        FTitle.DurationStr := StringReplace(LLine, 'ID_DVD_TITLE_' + FloatToStr(FTitleIndex) + '_LENGTH=', '', [rfReplaceAll]);
        Break;
      end;
    end;
    // search for audio streams
    for I := 0 to FProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FProcess.ConsoleOutput[i]);
      if Length(LLine) > 0 then
      begin
        if Audio = Copy(LLine, 1, Length(Audio)) then
        begin
          LSplitList := TStringList.Create;
          try
            LSplitList.StrictDelimiter := True;
            LSplitList.Delimiter := ':';
            LSplitList.DelimitedText := LLine;
            LAudioStream.Name := Trim(UpperCase(Trim(StringReplace(LSplitList[2], 'language', '', [rfReplaceAll])) + ', ' + Trim(StringReplace(LSplitList[3], 'aid', '', [rfReplaceAll]))));
            LAudioStream.ID := Trim(StringReplace(LSplitList[4], '.', '', [rfReplaceAll]));
            FTitle.AudioStreams.Add(LAudioStream);
          finally
            LSplitList.Free;
          end;
        end;
      end;
    end;
    // search for subtitle streams
    for I := 0 to FProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FProcess.ConsoleOutput[i]);
      if Length(LLine) > 0 then
      begin
        if Subtitle = Copy(LLine, 1, Length(Subtitle)) then
        begin
          LSplitList := TStringList.Create;
          try
            LSplitList.StrictDelimiter := True;
            LSplitList.Delimiter := ':';
            LSplitList.DelimitedText := LLine;
            LSubStream.Name := Trim(UpperCase(LSplitList[2]));
            LSubStream.ID := Trim(StringReplace(LSplitList[1], 'language', '', [rfReplaceAll]));
            FTitle.SubtitleStreams.Add(LSubStream);
          finally
            LSplitList.Free;
          end;
        end;
      end;
    end;
    // chapters
    for I := 0 to FProcess.ConsoleOutput.Count - 1 do
    begin
      LLine := Trim(FProcess.ConsoleOutput[i]);
      if Length(LLine) > 0 then
      begin
        if Chapter = Copy(LLine, 1, Length(Chapter)) then
        begin
          LSplitList := TStringList.Create;
          try
            LSplitList.StrictDelimiter := True;
            LSplitList.Delimiter := ',';
            LSplitList.DelimitedText := LLine;
            LSplitList.Delete(0); // first item is "chapters"
            // remove empty lines
            for j := LSplitList.Count - 1 downto 0 do
            begin
              if Length(Trim(LSplitList[j])) < 1 then
              begin
                LSplitList.Delete(j);
              end;
            end;
            FTitle.Chapters.AddStrings(LSplitList);
          finally
            LSplitList.Free;
          end;
        end;
      end;
    end;
    // chapter durations
    for i := 0 to FTitle.Chapters.Count - 1 do
    begin
      LLine := FTitle.Chapters[i];
      LLine := Copy(LLine, 1, Length(LLine) - 4);
      if i = 0 then
      begin
        FTitle.ChapterDurations.Add(TimeToInt(LLine));
      end
      else
      begin
        FTitle.ChapterDurations.Add(TimeToInt(LLine) - FTitle.ChapterDurations[i - 1]);
      end;
    end;
  finally
    FStatus := fsDone;
  end;
end;

procedure TDVDTitleInfoExtractor.Start;
begin
  FProcess.ApplicationName := FMPlayerPath;
  FProcess.CommandLine := ' -msglevel identify=6 -frames 0 -vo null -quiet dvd://' + FloatToStr(FTitleIndex) + ' -dvd-device "' + FDVDFolder + '"';
  FProcess.Run;
end;

function TDVDTitleInfoExtractor.TimeToInt(TimeStr: string): Integer;
var
  TimeList: TStringList;
  hour: Integer;
  minute: Integer;
  second: Integer;
begin

  Result := 0;

  if Length(TimeStr) = 8 then
  begin

    TimeList := TStringList.Create;
    try
      TimeList.Delimiter := ':';
      TimeList.StrictDelimiter := True;
      TimeList.DelimitedText := TimeStr;

      hour := 0;
      minute := 0;
      second := 0;

      if TimeList.Count = 3 then
      begin

        if IsStringNumeric(TimeList[0]) then
        begin
          hour := StrToInt(TimeList[0]);
        end;

        if IsStringNumeric(TimeList[1]) then
        begin
          minute := StrToInt(TimeList[1]);
        end;

        if IsStringNumeric(TimeList[2]) then
        begin
          second := StrToInt(TimeList[2]);
        end;

        Result := (hour * 3600) + (minute * 60) + second;

      end;

    finally
      FreeAndNil(TimeList);
    end;

  end;
end;

end.
