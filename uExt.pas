unit uExt;

interface

uses
  Winapi.Windows, System.SysUtils, DateUtils, Registry;

function GetInstallDate: TDateTime;
function GetInstallDateR(const InstallDate: TDateTime): string;

function GetSystemUptime: Double;
function GetSystemUptimeLocal: TDateTime;
function GetSystemUptimeR: string;

implementation

function GetSystemUILanguage: string;
var
  Buffer: array[0..LOCALE_NAME_MAX_LENGTH - 1] of WideChar;
begin
  if GetUserDefaultLocaleName(Buffer, Length(Buffer)) > 0 then
    Result := LowerCase(Buffer)
  else
    Result := 'en-us';
end;

function GetElapsedTime(const FromDate: TDateTime): string;
var
  cur, nowTime, diff: TDateTime;
  Years, Months, Days: Integer;
  Hours, Minutes, Seconds, MS: Word;
  lang: string;
begin
  if (FromDate <= 0) or (FromDate > Now) then
    Exit(' (0d 0h 0m 0s elapsed)');

  nowTime := Now;
  cur := FromDate;

  // 년 단위 차이 계산
  Years := YearsBetween(cur, nowTime);
  if IncYear(cur, Years) > nowTime then Dec(Years);
  cur := IncYear(cur, Years);

  // 월 단위 차이 계산
  Months := MonthsBetween(cur, nowTime);
  if IncMonth(cur, Months) > nowTime then Dec(Months);
  cur := IncMonth(cur, Months);

  // 일 단위 차이 계산
  Days := DaysBetween(cur, nowTime);
  cur := IncDay(cur, Days);

  // 남은 시간 (시, 분, 초) 계산
  diff := nowTime - cur;
  DecodeTime(diff, Hours, Minutes, Seconds, MS);

  lang := GetSystemUILanguage; // 시스템 UI 언어 가져옴 ('ko-kr', 'en-us')

  if SameText(lang, 'ko-kr') then
  begin
    // 1년 이상이면 년, 월, 일, 시, 분, 초 모두 표시
    if Years > 0 then
      Result := Format(' (%d년 %d개월 %d일 %d시간 %d분 %d초 경과)',
        [Years, Months, Days, Hours, Minutes, Seconds])
    // 1개월 이상이면 월, 일, 시, 분, 초 표시
    else if Months > 0 then
      Result := Format(' (%d개월 %d일 %d시간 %d분 %d초 경과)',
        [Months, Days, Hours, Minutes, Seconds])
    // 그 외에는 일, 시, 분, 초만 표시
    else
      Result := Format(' (%d일 %d시간 %d분 %d초 경과)',
        [Days, Hours, Minutes, Seconds]);
  end
  else
  begin
    if Years > 0 then
      Result := Format(' (%dy %dmo %dd %dh %dm %ds elapsed)',
        [Years, Months, Days, Hours, Minutes, Seconds])
    else if Months > 0 then
      Result := Format(' (%dmo %dd %dh %dm %ds elapsed)',
        [Months, Days, Hours, Minutes, Seconds])
    else
      Result := Format(' (%dd %dh %dm %ds elapsed)',
        [Days, Hours, Minutes, Seconds]);
  end;
end;

function GetInstallDate: TDateTime;
const
  xRegPath = 'Software\Microsoft\Windows NT\CurrentVersion';
var
  xReg: TRegistry;
  UnixTime: Cardinal;
begin
  Result := 0;
  xReg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    try
      xReg.RootKey := HKEY_LOCAL_MACHINE;
      if xReg.OpenKeyReadOnly(xRegPath) and xReg.ValueExists('InstallDate') then
      begin
        UnixTime := Cardinal(xReg.ReadInteger('InstallDate'));  // 설치 날짜 (Unix 타임스탬프)
        Result := UnixToDateTime(UnixTime, True);               // Unix 타임스탬프를 TDateTime으로 변환
        Result := TTimeZone.Local.ToLocalTime(Result);          // 로컬 시간대로 변환
      end;
    except
    end;
  finally
    xReg.Free;
  end;
end;

function GetInstallDateR(const InstallDate: TDateTime): string;
begin
  Result := GetElapsedTime(InstallDate);
end;

function GetSystemUptime: Double;
begin
  Result := GetTickCount64 / MSecsPerDay;
end;

function GetSystemUptimeLocal: TDateTime;
begin
  Result := Now - GetSystemUptime;
end;

function GetSystemUptimeR: string;
begin
  Result := GetElapsedTime(GetSystemUptimeLocal);
end;

end.
