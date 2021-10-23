sudo apt install golang
go get -d github.com/jstarks/npiperelay
GOOS=windows go build -o npiperelay.exe github.com/jstarks/npiperelay
sudo cp npiperelay.exe /usr/local/bin/
rm npiperelay.exe
