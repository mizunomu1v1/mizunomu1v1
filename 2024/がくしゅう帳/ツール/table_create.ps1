<# -------------------------------------
# 機能　：テーブル作成スクリプト
# 作成日：2024/10/11
#--------------------------------- #>

$returnPath=$PWD
$workPath="C:\file"
cd $workPath

$logPath="$workPath\log\create_table_log.txt"
$inputPath="$workPath\input\table.csv"
$outputPath="$workPath\output\"

$sysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# --------------------------------------------------

# 開始ログ
Write-Output "$sysdate 処理開始" | Out-File -Append $logPath

# .csv読み込み
$table = Import-Csv $inputPath -Encoding UTF8
$table | Format-Table
$tableName = $table[1].table_name
$outputFile="$outputPath$tableName.sql"

# .sql書き込み
Write-Output "CREATE TABLE $tableName (" | Out-File $outputFile

cd $returnPath

# CSVファイルの読み込み
# for /f "skip=1 delims=, tokens=1-3" %%a in (%input%) do ( 
# 	echo 名前　　:%%a
# 	echo 生年月日:%%b
# 	echo 性別　　:%%c
# 	echo.
# )


# 入力CSVファイル読み込み
# echo "CREATE TABLE" %table_name% "(" >> %$output%

# create table mybook (
#   id integer, 
#   name varchar(10)
# );
