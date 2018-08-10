AppName=FangYou
App: Archive Export
	
Archive:
	xcodebuild archive -workspace $(AppName).xcworkspace -scheme $(AppName) -archivePath $(AppName).xcarchive -configuration Debug
Export:
	xcodebuild -exportArchive -archivePath $(AppName).xcarchive -exportPath $(AppName)_ipa  -exportOptionsPlist ./options.plist
Upload_pgy:
	curl -F "file=@./FangYou_ipa/FangYou.ipa" -F "uKey=24a8d4d8d482bfc94678056b2fb98036" -F "_api_key=9613e0a13e6c34c1d7b41b604cb920b4" https://qiniu-storage.pgyer.com/apiv1/app/upload
pod:
	pod install
clean_all:
	rm -fr ./*build ./*.build ./pods ./Release-iphoneos ./*.ipa ./Podfile.lock *.xcarchive $(AppName)_ipa
clean:
	rm -fr ./*build ./*.build ./Release-iphoneos ./*.ipa *.xcarchive $(AppName)_ipa
