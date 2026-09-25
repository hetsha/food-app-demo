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
  if (FocusOk) { return }
  Sh "monkey -p com.parabdi.parabdi -c android.intent.category.LAUNCHER 1" | Out-Null
  Start-Sleep -Seconds 3
}
function Tap-Desc([string]$xml, [string]$pattern) {
  $m = [regex]::Matches($xml, 'content-desc="([^"]*)"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"') |
    Where-Object { $_.Groups[1].Value -like "*$pattern*" } | Select-Object -First 1
  if (-not $m) { return $false }
  Ensure-Focus
  $x = [int](($m.Groups[2].Value + $m.Groups[4].Value) / 2)
  $y = [int](($m.Groups[3].Value + $m.Groups[5].Value) / 2)
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
    if ($w -ge 160 -and $w -le 210 -and $h -ge 160 -and $h -le 210) {
      $tiles += [pscustomobject]@{ X1=$x1; Y1=$y1; X2=$x2; Y2=$y2; CX=[int](($x1+$x2)/2); CY=[int](($y1+$y2)/2); W=$w; H=$h }
    }
  }
  $sorted = $tiles | Sort-Object Y1, X1
  return @($sorted)
}

# ---- Step 1: land on Home ----
Ensure-Focus
$xml = Get-Ui
if ($xml -notmatch 'Choose your avatar') {
  $null = Tap-Desc $xml 'Tab 1 of 5'
  Start-Sleep -Seconds 1
  $xml = Get-Ui
}
if ($xml -notmatch 'Choose your avatar') { Grab "_v_err1"; Write-Output "ERR: not on home"; exit 1 }
Grab "_v1_home_before"

# ---- Step 2: open avatar sheet ----
$null = Tap-Desc $xml 'Choose your avatar'
Start-Sleep -Milliseconds 1500
$xml = Get-Ui
if ($xml -notmatch 'Pick a look that feels like you' -and $xml -notmatch 'Men') { Grab "_v_err2"; Write-Output "ERR: sheet not open"; exit 1 }
Grab "_v2_sheet_open"

# ---- Step 3: pick female_4 (women row, 4th) ----
$tiles = Get-Tiles $xml
Write-Output "tiles found: $($tiles.Count)"
for ($i=0; $i -lt $tiles.Count; $i++) { Write-Output "  tile[$i] c=($($tiles[$i].CX),$($tiles[$i].CY)) w=$($tiles[$i].W)" }
if ($tiles.Count -lt 10) { Grab "_v_err3"; Write-Output "ERR: expected 10 tiles"; exit 1 }
$t = $tiles[8]  # women row 4th = female_4
Ensure-Focus
& $adb shell input tap $t.CX $t.CY
Start-Sleep -Milliseconds 700
Grab "_v3_tile_selected"

# ---- Step 4: tap Save ----
$xml = Get-Ui
$ok = Tap-Desc $xml 'Save'
if (-not $ok) { Write-Output "ERR: save button not found"; Grab "_v_err4"; exit 1 }
Start-Sleep -Milliseconds 1200
$xml = Get-Ui
Grab "_v4_home_after"
if ($xml -notmatch 'Choose your avatar') { Write-Output "WARN: back on unexpected screen after save" }
Write-Output "DONE avatar-flow"
