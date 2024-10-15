<# -------------------------------------
# 機能　：テーブル作成スクリプト
# 作成日：2024/10/11
#--------------------------------- #>

# 作業フォルダ移動
$returnPath = $PWD
$workPath = "C:\file"
Set-Location $workPath

# パス定義
$logPath = "$workPath\log\create_table_log.txt"
$inputPath = "$workPath\input\table.csv"
$outputPath = "$workPath\output\"

# 開始ログ出力
$startSysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Output "$startSysdate 処理開始" | Out-File -Append $logPath

# .csv読み込み
$datas = Import-Csv $inputPath -Encoding UTF8
$datas | Format-Table # 標準出力に表形式で出力
$tableName = $datas[1].table_name
$outputFile = Join-Path -Path $outputPath -ChildPath "$tableName.sql"

# .sql書き込み
Write-Output "CREATE TABLE $tableName (" | Out-File $outputFile

# カラムを設定する
$columns = @()
foreach ($data in $datas) {
	if (-not [string]::IsNullOrEmpty($data.max_length)) {
		$columns += "$($data.column_name) $($data.column_type)($($data.max_length)),"
	}
	else {
		$columns += "$($data.column_name) $($data.column_type),"
	}
}

# カラムをカンマで結合し出力
$columnText = $columns -join "`r`n   "
Write-Output "   $columnText" | Out-File -Append $outputFile

# 複合主キーを設定する
foreach ($data in $datas) {
	if (-not [string]::IsNullOrEmpty($data.pk)) {
		$pks += $data.column_name
	}
}
# 主キーをカンマで結合し出力
$pkText = $pks -join ", "
Write-Output "   PRIMARY KEY($($pkText))" | Out-File -Append $outputFile
Write-Output "   ); " | Out-File -Append $outputFile
	
# コメントを設定する
$comments = $datas | ForEach-Object {
	"COMMENT ON COLUMN $tableName.$($_.column_name) IS '$($_.remarks)'; "
}
# コメントを結合し出力
$commentText = $comments -join "`r`n"
Write-Output "$commentText" | Out-File -Append $outputFile

# 元のフォルダに戻る
Set-Location $returnPath

# 終了ログ出力
$endSysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Output "$endSysdate 処理終了" | Out-File -Append $logPath