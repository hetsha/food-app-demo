$adb = "D:\scrcpy-win64-v4.1\adb.exe"

function Sh([string]$cmd) { return (& $adb shell $cmd | Out-String).Trim() }
function Get-Ui { return (Sh "uiautomator dump /sdcard/ui.xml 2>/dev/null; cat /sdcard/ui.xml") }
function Grab([string]$name) {
  Sh "rm -f /sdcard/s.png; screencap -p /sdcard/s.png" | Out-Null
  & $adb pull /sdcard/s.png "D:\food-app-demo\$name.png" | Out-Null
  Write-Output "SHOT $name"
}
function FocusOk { return ((Sh "dumpsys window | grep mCurrentFocus") -match "com.parabdi.parabdi") }
function Ensure-Focus {
  if (FocusOk) { return $true }
  Sh "monkey -p com.parabdi.parabdi -c android.intent.category.LAUNCHER 1" | Out-Null
  Start-Sleep -Seconds 3
  return (FocusOk)
}
function Tap-Desc([string]$xml, [string]$pattern) {
  $m = [regex]::Matches($xml, 'content-desc="([^"]*)"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"') |
    Where-Object { $_.Groups[1].Value -like "*$pattern*" } | Select-Object -First 1
  if (-not $m) { return $false }
  $null = Ensure-Focus
  $x = ([int]$m.Groups[2].Value + [int]$m.Groups[4].Value) / 2
  $y = ([int]$m.Groups[3].Value + [int]$m.Groups[5].Value) / 2
  Write-Output "TAP '$pattern' -> ($x,$y)"
  & $adb shell input tap $x $y
  return $true
}
function Get-Tiles([string]$xml) {
  $nodes = [regex]::Matches($xml, 'content-desc=""[^>]*clickable="true"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"')
  $tiles = @()
  foreach ($n in $nodes) {
    $x1=[int]$n.Groups[1].Value; $y1=[int]$n.Groups[2].Value
    $x2=[int]$n.Groups[3].Value; $y2=[int]$n.Groups[4].Value
    $w=$x2-$x1; $h=$y2-$y1
    if ($w -ge 150 -and $w -le 230 -and $h -ge 150 -and $h -le 230) {
      $tiles += [pscustomobject]@{ X1=$x1; Y1=$y1; CX=[int](($x1+$x2)/2); CY=[int](($y1+$y2)/2); W=$w }
    }
  }
  return @($tiles | Sort-Object Y1, X1)
}

# ---- 1. Back out of any pushed routes until bottom nav visible ----
for ($i=0; $i -lt 5; $i++) {
  $xml = Get-Ui
  if ($xml -match 'Tab 1 of 5' -or $xml -match 'Choose your avatar') { break }
  Sh "input keyevent KEYCODE_BACK" | Out-Null
  Start-Sleep -Milliseconds 900
}

# ---- 2. Land on Home tab ----
$xml = Get-Ui
if ($xml -notmatch 'Choose your avatar') {
  if (-not (Tap-Desc $xml 'Tab 1 of 5')) { $null = Ensure-Focus }
  Start-Sleep -Milliseconds 1200
  $xml = Get-Ui
}
if ($xml -notmatch 'Choose your avatar') {
  Sh "monkey -p com.parabdi.parabdi -c android.intent.category.LAUNCHER 1" | Out-Null
  Start-Sleep -Seconds 4
  $xml = Get-Ui
}
if ($xml -notmatch 'Choose your avatar') { Grab "_v_err1"; Write-Output "ERR: not on home"; exit 1 }
Grab "_v1_home_before"

# ---- 3. Open avatar sheet (retry up to 3) ----
$sheetOk = $false
for ($i=1; $i -le 3; $i++) {
  $xml = Get-Ui
  if ($xml -match 'Pick a look that feels like you') { $sheetOk = $true; break }
  $null = Tap-Desc $xml 'Choose your avatar'
  Start-Sleep -Milliseconds 1400
  $xml = Get-Ui
  if ($xml -match 'Pick a look that feels like you') { $sheetOk = $true; break }
}
if (-not $sheetOk) { Grab "_v_err2"; Write-Output "ERR: sheet not open"; exit 1 }
Grab "_v2_sheet_open"

# ---- 4. Select female_4 (women row, index 8) ----
$tiles = Get-Tiles $xml
Write-Output "tiles=$($tiles.Count)"
for ($i=0; $i -lt $tiles.Count; $i++) { Write-Output "  t[$i]=($($tiles[$i].CX),$($tiles[$i].CY)) w=$($tiles[$i].W)" }
if ($tiles.Count -lt 10) { Grab "_v_err3"; Write-Output "ERR: tiles < 10"; exit 1 }
$null = Ensure-Focus
$t = $tiles[8]
& $adb shell input tap $t.CX $t.CY
Start-Sleep -Milliseconds 800
Grab "_v3_tile_selected"

# ---- 5. Save ----
$saved = $false
for ($i=1; $i -le 3; $i++) {
  $xml = Get-Ui
  if ($xml -notmatch 'Pick a look that feels like you') {
    # sheet dismissed externally - reopen once if we still can
    $null = Tap-Desc $xml 'Choose your avatar'
    Start-Sleep -Milliseconds 1400
    $xml = Get-Ui
    if ($xml -match 'Pick a look that feels like you') {
      $tiles2 = Get-Tiles $xml
      if ($tiles2.Count -ge 10) { $null = Ensure-Focus; & $adb shell input tap $tiles2[8].CX $tiles2[8].CY; Start-Sleep -Milliseconds 600 }
    } else { continue }
  }
  if (Tap-Desc $xml 'Save') { Start-Sleep -Milliseconds 1300; $saved = $true; break }
}
if (-not $saved) { Grab "_v_err4"; Write-Output "ERR: could not save"; exit 1 }
$xml = Get-Ui
Grab "_v4_home_after"
if ($xml -match 'Choose your avatar') { Write-Output "DONE avatar-flow OK" } else { Write-Output "DONE avatar-flow (screen changed after save)" }
