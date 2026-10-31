param([string]$Name)
$workspace = $PSScriptRoot
if (-not $Name) { $Name = Read-Host "请输入新C项目的文件夹名（英文或拼音）" }
$Name = $Name.Trim()
if (-not $Name) { Write-Host "未输入名称，已取消。" -ForegroundColor Yellow; exit }
$proj = Join-Path $workspace $Name
if (Test-Path -LiteralPath $proj) { Write-Host "已存在同名文件夹：$proj" -ForegroundColor Red; exit }
$src = Join-Path $proj "src"
$build = Join-Path $proj "build"
$vs = Join-Path $proj ".vscode"
New-Item -ItemType Directory -Force -Path $src, $build, $vs | Out-Null
$settings = @'
{
    "code-runner.executorMap": {
        "c": "cd $dir; cd ..; if (-not (Test-Path build)) { mkdir build | Out-Null }; gcc src\\$fileName -o build\\$fileNameWithoutExt; if ($LASTEXITCODE -eq 0) { .\\build\\$fileNameWithoutExt }"
    },
    "code-runner.runInTerminal": true,
    "code-runner.saveFileBeforeRun": true
}
'@
[IO.File]::WriteAllText((Join-Path $vs "settings.json"), $settings, (New-Object Text.UTF8Encoding $false))
Write-Host "`n项目已创建：$proj" -ForegroundColor Green
Write-Host "结构：src（放.c源码） / build（放exe） / .vscode（已配好Code Runner）"
Write-Host "用法：.c 源码放进 src，用 VS Code 打开 $proj，打开 src 里的文件按 Ctrl+Alt+N 即可运行。`n" -ForegroundColor Cyan
