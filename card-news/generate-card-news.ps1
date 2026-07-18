Add-Type -AssemblyName System.Drawing

$QUOTES = @(
  "야근은 계획, 잔소리는 기본 옵션.",
  "완벽한 보고서보다 완벽한 침묵이 나을 때가 있다.",
  "상사의 '빨리'는 번역하면 대략 3일이다.",
  "체크리스트가 늘어날수록 퇴근은 늦어진다.",
  "커피 한 잔의 평화, 그리고 곧이어 오는 메신저 알림.",
  "잔소리는 흘려듣고, 할 일만 건져내자.",
  "월요일은 인류가 발명한 것 중 가장 잔인한 시간 단위.",
  "숨은 할 일 찾기: 오늘도 클리어.",
  "퇴근 5분 전 카톡: `"잠깐 통화 가능해?`"",
  "회의는 길어지고 결론은 다음 회의로 미뤄진다."
)

$EXAMPLES = @(
  @{ before = "야 너 이거 왜 아직도 안 끝났어?"; after = "진행 상황이 어떻게 되는지 여쭤봐도 될까요?" },
  @{ before = "제대로 좀 확인하고 보내라고 했잖아."; after = "조금 더 꼼꼼히 확인 후 보내주시면 좋을 것 같아요." },
  @{ before = "정신 좀 차리세요."; after = "조금 더 집중해 주시면 감사하겠습니다." }
)

$bg = [System.Drawing.ColorTranslator]::FromHtml('#0B0F0E')
$surface2 = [System.Drawing.ColorTranslator]::FromHtml('#1B231F')
$accent = [System.Drawing.ColorTranslator]::FromHtml('#4FD8A8')
$raw = [System.Drawing.ColorTranslator]::FromHtml('#FF8A5C')
$rawSoft = [System.Drawing.ColorTranslator]::FromHtml('#2E211B')
$accentSoft = [System.Drawing.ColorTranslator]::FromHtml('#1E332C')
$textColor = [System.Drawing.ColorTranslator]::FromHtml('#ECF2EF')

function Wrap-Text($g, $str, $font, $maxWidth) {
  $words = $str -split ' '
  $lines = @()
  $current = ""
  foreach ($w in $words) {
    $test = if ($current) { "$current $w" } else { $w }
    $sz = $g.MeasureString($test, $font)
    if ($sz.Width -gt $maxWidth -and $current) {
      $lines += $current
      $current = $w
    } else {
      $current = $test
    }
  }
  if ($current) { $lines += $current }
  return $lines
}

$size = 1080
$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
$g.Clear($bg)

$barRect = New-Object System.Drawing.Rectangle(0, 0, $size, 14)
$gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($barRect, $raw, $accent, 0.0)
$g.FillRectangle($gradBrush, $barRect)

$mode = Get-Random -Minimum 0 -Maximum 2

if ($mode -eq 0) {
  $quote = $QUOTES | Get-Random
  $badgeFont = New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)
  $g.DrawString("직장인 공감", $badgeFont, (New-Object System.Drawing.SolidBrush($accent)), 70, 80)

  $quoteFont = New-Object System.Drawing.Font("Malgun Gothic", 56, [System.Drawing.FontStyle]::Bold)
  $lines = Wrap-Text $g $quote $quoteFont ($size - 140)
  $lineHeight = 78
  $totalHeight = $lines.Count * $lineHeight
  $y = ($size - $totalHeight) / 2
  foreach ($line in $lines) {
    $g.DrawString($line, $quoteFont, (New-Object System.Drawing.SolidBrush($textColor)), 70, $y)
    $y += $lineHeight
  }
} else {
  $ex = $EXAMPLES | Get-Random
  $badgeFont = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Bold)
  $g.DrawString("BEFORE -> AFTER", $badgeFont, (New-Object System.Drawing.SolidBrush($accent)), 70, 80)

  $labelFont = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
  $bodyFont = New-Object System.Drawing.Font("Malgun Gothic", 34)

  $rawBoxY = 220
  $rawBoxH = 260
  $g.FillRectangle((New-Object System.Drawing.SolidBrush($rawSoft)), 70, $rawBoxY, ($size - 140), $rawBoxH)
  $g.DrawString("상사가 이렇게 말하면", $labelFont, (New-Object System.Drawing.SolidBrush($raw)), 100, ($rawBoxY + 30))
  $beforeLines = Wrap-Text $g $ex.before $bodyFont ($size - 260)
  $by = $rawBoxY + 80
  foreach ($line in $beforeLines) {
    $g.DrawString($line, $bodyFont, (New-Object System.Drawing.SolidBrush($textColor)), 100, $by)
    $by += 46
  }

  $arrowFont = New-Object System.Drawing.Font("Malgun Gothic", 40, [System.Drawing.FontStyle]::Bold)
  $g.DrawString([char]0x2193, $arrowFont, (New-Object System.Drawing.SolidBrush($accent)), ($size / 2 - 20), ($rawBoxY + $rawBoxH + 15))

  $softBoxY = $rawBoxY + $rawBoxH + 90
  $softBoxH = 260
  $g.FillRectangle((New-Object System.Drawing.SolidBrush($accentSoft)), 70, $softBoxY, ($size - 140), $softBoxH)
  $g.DrawString("이렇게 순화돼요", $labelFont, (New-Object System.Drawing.SolidBrush($accent)), 100, ($softBoxY + 30))
  $afterLines = Wrap-Text $g $ex.after $bodyFont ($size - 260)
  $ay = $softBoxY + 80
  foreach ($line in $afterLines) {
    $g.DrawString($line, $bodyFont, (New-Object System.Drawing.SolidBrush($textColor)), 100, $ay)
    $ay += 46
  }
}

$footerY = $size - 120
$g.FillRectangle((New-Object System.Drawing.SolidBrush($surface2)), 70, $footerY, ($size - 140), 70)
$footerFont = New-Object System.Drawing.Font("Malgun Gothic", 26, [System.Drawing.FontStyle]::Bold)
$g.DrawString("잔소리 필터기 · 무료 · 회원가입 없음", $footerFont, (New-Object System.Drawing.SolidBrush($accent)), 100, ($footerY + 18))

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outPath = Join-Path $PSScriptRoot "카드뉴스_$timestamp.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Output $outPath

