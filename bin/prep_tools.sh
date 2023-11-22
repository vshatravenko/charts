#!/usr/bin/env sh

set -e

HELM_VERSION=3.12.2
RCLONE_VERSION=current

main() {
	sudo apt update -qq
	sudo apt install -yq curl unzip

	install_rclone
	install_helm
}

install_rclone() {
	curl -so rclone.zip https://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-amd64.zip
	unzip -q rclone.zip
	chmod +x rclone-*-linux-amd64/rclone
	sudo mv rclone-*-linux-amd64/rclone /usr/local/bin
}


install_helm() {
	curl -so helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
	tar xzf helm.tar.gz
	chmod +x linux-amd64/helm
	sudo mv linux-amd64/helm /usr/local/bin
}

main "$@"
