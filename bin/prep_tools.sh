#!/usr/bin/env sh

set -e

HELM_VERSION=3.12.2
RCLONE_VERSION=current

main() {
	sudo apt update -q
	sudo apt install -y curl unzip

	install_rclone
	install_helm
}

install_rclone() {
	curl -o rclone.zip https://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-amd64.zip
	unzip rclone.zip
	chmod +x rclone-*-linux-amd64/rclone
	sudo mv rclone-*-linux-amd64/rclone /usr/local/bin
}


install_helm() {
	curl -o helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
	tar xzf helm.tar.gz
	chmod +x linux-amd64/helm
	sudo mv linux-amd64/helm /usr/local/bin
}

main "$@"
