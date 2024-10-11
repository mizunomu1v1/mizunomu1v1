<# -------------------------------------
# �@�\�@�F�e�[�u���쐬�X�N���v�g
# �쐬���F2024/10/11
#--------------------------------- #>

$returnPath=$PWD
$workPath="C:\file"
cd $workPath

$logPath="$workPath\log\create_table_log.txt"
$inputPath="$workPath\input\table.csv"
$outputPath="$workPath\output\"

$sysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# --------------------------------------------------

# �J�n���O
Write-Output "$sysdate �����J�n" | Out-File -Append $logPath

# .csv�ǂݍ���
$table = Import-Csv $inputPath -Encoding UTF8
$table | Format-Table
$tableName = $table[1].table_name
$outputFile="$outputPath$tableName.sql"

# .sql��������
Write-Output "CREATE TABLE $tableName (" | Out-File $outputFile

cd $returnPath

# CSV�t�@�C���̓ǂݍ���
# for /f "skip=1 delims=, tokens=1-3" %%a in (%input%) do ( 
# 	echo ���O�@�@:%%a
# 	echo ���N����:%%b
# 	echo ���ʁ@�@:%%c
# 	echo.
# )


# ����CSV�t�@�C���ǂݍ���
# echo "CREATE TABLE" %table_name% "(" >> %$output%

# create table mybook (
#   id integer, 
#   name varchar(10)
# );
