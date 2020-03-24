TITLE HTML CONVERSION - EPUB3 - Version1

COLOR a
@echo off
cls
@echo Start time: %time%
set STARTTIME=%TIME%

XCOPY /Y \\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\02-Remove-xmlns.xslt
REN *.xml *.sgml
rem set CP=C:\Saxon\saxon-he-9.3.0.5.jar;
set CP=\\D:\Saxon\saxon-he-9.3.0.5.jar;
CLS



for /R %%b IN (*.docx) DO (
 TITLE HTML CONVERSION - EPUB3: %%~nb.docx
 set filename="%%~nb"
 echo File: %%~nb
 REM start "" "\\10.1.1.100\Automation\WORD2XML\JoinTags\1.0.5\JoinTags.exe" "%CD%"
 rem "\\10.1.1.100\Automation\Perl\bin\perl.exe" "\\10.1.1.100\automation\WORD2XML\Word2HTML5-EPUB\00-UNZIP.pl" "%%b"
 "C:\Perl\bin\perl.exe" "00-UNZIP.pl" "%%b"
echo
echo hai
pause
)



TIMEOUT /T 3
for /R %%f IN (*.xml) DO (
rem java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out2.xml" "%%~nf.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\Bookmark.xslt"
java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out2.xml" "%%~nf.xml" "Bookmark.xslt"
cls
echo 11111111111
pause

 java -cp %CP% net.sf.saxon.Transform -t -o:"%%~nf-out222.xml" "%%~nf-out2.xml" "02-Remove-xmlns.xslt"
 pause
java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out3.xml" "%%~nf-out222.xml" "01-W2H-CK.xslt"
echo haiiiii
pause
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out4.xml" "%%~nf-out3.xml" "02-Remove-xmlns.xslt" 
echo checkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
pause
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out5.xml" "%%~nf-out4.xml" "1-LIST.xslt"
echo 1 list
pause
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\2-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "2-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\3-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "3-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\35-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "35-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out9.xml" "%%~nf-out8.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\4-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out9.xml" "%%~nf-out8.xml" "4-LIST.xslt"
echo 4-list completed - out8
pause
REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ JOIN-ELEMENTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

 java -cp %CP% net.sf.saxon.Transform -t -o:"%%~nf-out10.xml" "%%~nf-out9.xml" "02-Remove-xmlns.xslt"
echo 11111234567890
pause

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ JOIN-ELEMENTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out11.xml" "%%~nf-out10.xml" "03-Final.xslt"
    echo xxxxxxxxxxxxxxxxxxxxxx
    pause
   rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf.xhtml" "%%~nf.xhtml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\join-elements.xslt"
   java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out12.xml" "%%~nf-out11.xml" "join-elements.xslt"
   
   java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out13.xml" "%%~nf-out12.xml" "01_RemoveNameSpace.xsl"
   
   java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out14.xml" "%%~nf-out13.xml" "head1_split_into_scetion.xslt"
   
   java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-Final_Out.xml" "%%~nf-out14.xml" "Final_Xml.xslt"
   
    echo finallllll
pause
del %%~nf.xml
del %%~nf-out2.xml
del %%~nf-out3.xml
del %%~nf-out4.xml
del %%~nf-out5.xml
del %%~nf-out6.xml
del %%~nf-out7.xml
del %%~nf-out8.xml
del %%~nf-out9.xml
del %%~nf-out10.xml
del %%~nf-out11.xml
echo minus 5seconds

REM pause

)





