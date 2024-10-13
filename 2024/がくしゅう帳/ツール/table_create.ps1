<# -------------------------------------
# �@�\�@�F�e�[�u���쐬�X�N���v�g
# �쐬���F2024/10/11
#--------------------------------- #>

# ��ƃt�H���_�ړ�
$returnPath = $PWD
$workPath = "C:\file"
Set-Location $workPath

# �p�X��`
$logPath = "$workPath\log\create_table_log.txt"
$inputPath = "$workPath\input\table.csv"
$outputPath = "$workPath\output\"

# �J�n���O�o��
$startSysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Output "$startSysdate �����J�n" | Out-File -Append $logPath

# .csv�ǂݍ���
$datas = Import-Csv $inputPath -Encoding UTF8
$datas | Format-Table # �W���o�͂ɕ\�`���ŏo��
$tableName = $datas[1].table_name
$outputFile = Join-Path -Path $outputPath -ChildPath "$tableName.sql"

# .sql��������
Write-Output "CREATE TABLE $tableName (" | Out-File $outputFile

# �J������ݒ肷��
$columns = @()
foreach ($data in $datas) {
	if (-not [string]::IsNullOrEmpty($data.max_length)) {
		$columns += "$($data.column_name) $($data.column_type)($($data.max_length)),"
	}
	else {
		$columns += "$($data.column_name) $($data.column_type),"
	}
}

# �J�������J���}�Ō������o��
$columnText = $columns -join "`r`n   "
Write-Output "   $columnText" | Out-File -Append $outputFile

# ������L�[��ݒ肷��
foreach ($data in $datas) {
	if (-not [string]::IsNullOrEmpty($data.pk)) {
		$pks += $data.column_name
	}
}
# ��L�[���J���}�Ō������o��
$pkText = $pks -join ", "
Write-Output "   PRIMARY KEY($($pkText))" | Out-File -Append $outputFile
Write-Output "   ); " | Out-File -Append $outputFile
	
# �R�����g��ݒ肷��
$comments = $datas | ForEach-Object {
	"COMMENT ON COLUMN $tableName.$($_.column_name) IS '$($_.remarks)'; "
}
# �R�����g���������o��
$commentText = $comments -join "`r`n"
Write-Output "$commentText" | Out-File -Append $outputFile

# ���̃t�H���_�ɖ߂�
Set-Location $returnPath

# �I�����O�o��
$endSysdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Output "$endSysdate �����I��" | Out-File -Append $logPath