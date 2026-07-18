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

$HASHTAGS = "#직장인공감 #직장인밈 #오피스라이프 #퇴사각 #월급루팡 #상사잔소리"

$mode = Get-Random -Minimum 0 -Maximum 2

if ($mode -eq 0) {
  $quote = $QUOTES | Get-Random
  $caption = "$quote 🙃`n`n상사 잔소리, 이제 순화해서 답장하세요.`n무료 · 회원가입 없음 · 링크는 프로필에 👆`n`n$HASHTAGS"
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
  $caption = "상사가 `"$($ex.before)`"라고 하면... 저는 이렇게 답장해요:`n`"$($ex.after)`"`n`n잔소리 순화기, 무료로 써보세요.`n링크는 프로필에 👆`n`n$HASHTAGS"
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

$captionPath = Join-Path $PSScriptRoot "카드뉴스_$timestamp.txt"
Set-Content -Path $captionPath -Value $caption -Encoding UTF8

$latestImagePath = Join-Path $PSScriptRoot "latest.png"
Copy-Item -Path $outPath -Destination $latestImagePath -Force

function HtmlEscape($s) {
  $s = $s -replace '&', '&amp;'
  $s = $s -replace '<', '&lt;'
  $s = $s -replace '>', '&gt;'
  return $s
}
$today = Get-Date -Format "yyyy-MM-dd"
$captionHtml = (HtmlEscape $caption) -replace "`n", "<br>"

$pageHtml = @"
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex, nofollow">
<title>오늘의 카드뉴스 · 잔소리 필터기</title>
<style>
  body { margin:0; background:#0B0F0E; color:#ECF2EF; font-family:-apple-system,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; padding:20px; }
  .wrap { max-width:480px; margin:0 auto; display:flex; flex-direction:column; gap:16px; }
  h1 { font-size:18px; margin:8px 0 0; }
  .date { color:#8FA098; font-size:13px; }
  img { width:100%; border-radius:16px; border:1px solid #26302B; display:block; }
  .caption-box { background:#1B231F; border:1px solid #26302B; border-radius:12px; padding:16px; font-size:14px; line-height:1.6; white-space:pre-wrap; }
  button { width:100%; padding:14px; border:none; border-radius:10px; background:#4FD8A8; color:#06120D; font-weight:700; font-size:15px; cursor:pointer; }
  button.copied { background:#2FB98C; }
  a.back { color:#8FA098; font-size:13px; text-align:center; text-decoration:none; }
</style>
</head>
<body>
  <div class="wrap">
    <div>
      <h1>오늘의 카드뉴스</h1>
      <div class="date">$today 생성 · 매일 아침 자동 갱신</div>
    </div>
    <img src="latest.png?v=$timestamp" alt="오늘의 카드뉴스 이미지">
    <div class="caption-box" id="caption">$captionHtml</div>
    <button id="copyBtn" type="button">캡션 복사하기</button>
    <a class="back" href="/">← 잔소리 필터기로 가기</a>
  </div>
<script>
document.getElementById('copyBtn').addEventListener('click', function () {
  var text = document.getElementById('caption').innerText;
  var btn = this;
  function done() {
    btn.textContent = '복사됨!';
    btn.classList.add('copied');
    setTimeout(function () { btn.textContent = '캡션 복사하기'; btn.classList.remove('copied'); }, 1400);
  }
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(done).catch(done);
  } else {
    var ta = document.createElement('textarea');
    ta.value = text;
    document.body.appendChild(ta);
    ta.select();
    try { document.execCommand('copy'); } catch (e) {}
    document.body.removeChild(ta);
    done();
  }
});
</script>
</body>
</html>
"@

$indexPath = Join-Path $PSScriptRoot "index.html"
Set-Content -Path $indexPath -Value $pageHtml -Encoding UTF8

Write-Output "IMAGE: $outPath"
Write-Output "CAPTION: $captionPath"
Write-Output "PAGE: $indexPath (+ latest.png)"

