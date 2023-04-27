### NixOS-Config
- My personal nixos configuration
- Use [deploy-rs](https://github.com/serokell/deploy-rs) to avoid the problem of difficult use of network proxies in NixOS.
#### Auto deploy and infrom
- Use [Github api](https://support.github.com/features/rest-api) to get the newest version of my nixos configuration every 10 seconds.
- Use Dingding group bot to infrom me the details of deployment.
- Requirememts:
	- python: dingtalkchatbot
	- Environment variable:
		- WEBHOOK: Dingding group bot webhook
		- SERCET: Dingding group bot sercet
		- OAUTH: Github OAuth client ID with client secret in this format: `ID:secret`
- I use `echo blah to /proc/acpi/ibm/fan` because I run it on a Ubuntu in a Thinkpad. If you use a different machine or a vm, please remove it.
### Acknowledgements
- [Wuhan Deepin Technology Co.,Ltd.](http://www.deepin.org/)
- [deepin-wine-wechat-arch](https://github.com/vufa/deepin-wine-wechat-arch) by [vufa](https://github.com/vufa)
- [deepin-wine-tim-arch](https://github.com/vufa/deepin-wine-tim-arch) by [vufa](https://github.com/vufa)
- [deploy-rs](https://github.com/serokell/deploy-rs)
- [nixpkgs](https://github.com/NixOS/nixpkgs)