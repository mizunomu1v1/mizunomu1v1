@REM ------------------------------------------------------
@REM �@�\�@�F�e�[�u���쐬�X�N���v�g
@REM �쐬���F2024/10/11
@REM ------------------------------------------------------

@REM �x�����ϐ��̓W�J
setlocal enabledelayedexpansion

cd  C:\file
set log=C:\file\log\create_table_log.txt
set input=C:\file\input\table.csv
set output=C:\file\output\create_table.sql

@REM �J�n���O
echo %DATE% %TIME% �����J�n>> %log%
echo;  >> %log%

@REM CSV�t�@�C���̓ǂݍ���
for /f "skip=1 delims=, tokens=1-3" %%a in (%input%) do ( 
	echo ���O�@�@:%%a
	echo ���N����:%%b
	echo ���ʁ@�@:%%c
	echo.
)


@REM ����CSV�t�@�C���ǂݍ���
@REM echo "CREATE TABLE" %table_name% "(" >> %$output%

@REM create table mybook (
@REM   id integer, 
@REM   name varchar(10)
@REM );
