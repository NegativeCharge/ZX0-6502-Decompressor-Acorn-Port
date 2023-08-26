cd .\tests\
for %%x in (*.zx0) do del "%%x" 
for %%x in (*.bin) do ..\tools\zx0.exe "%%x" "%%~nx.bin.zx0"

cd ..
cmd /c "BeebAsm.exe -v -i zx0_test.s.asm -do zx0_test.ssd -opt 3"