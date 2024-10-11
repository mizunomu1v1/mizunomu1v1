@REM ------------------------------------------------------
@REM 機能　：テーブル作成スクリプト
@REM 作成日：2024/10/11
@REM ------------------------------------------------------

@REM 遅延環境変数の展開
setlocal enabledelayedexpansion

cd  C:\file
set log=C:\file\log\create_table_log.txt
set input=C:\file\input\table.csv
set output=C:\file\output\create_table.sql

@REM 開始ログ
echo %DATE% %TIME% 処理開始>> %log%
echo;  >> %log%

@REM CSVファイルの読み込み
for /f "skip=1 delims=, tokens=1-3" %%a in (%input%) do ( 
	echo 名前　　:%%a
	echo 生年月日:%%b
	echo 性別　　:%%c
	echo.
)


@REM 入力CSVファイル読み込み
@REM echo "CREATE TABLE" %table_name% "(" >> %$output%

@REM create table mybook (
@REM   id integer, 
@REM   name varchar(10)
@REM );
