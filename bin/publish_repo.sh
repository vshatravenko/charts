#!/usr/bin/env sh

set -e

SOURCE_DIR="src"
OUTPUT_DIR="output"
CHARTS_HOST=${CHARTS_HOST:-"charts.2d33p.cloud"}
PUBLISH_ENABLED=${CHARTS_PUBLISH_ENABLED:-"true"}
CHARTS_S3_PROVIDER=${CHARTS_S3_PROVIDER:-"Cloudflare"}
CHARTS_S3_BUCKET=${CHARTS_S3_BUCKET:-"charts"}

main() {
	build

	if [ "$PUBLISH_ENABLED" = "true" ]; then
		render_rclone_conf
		publish
	fi
}

build() {
	mkdir -p ${OUTPUT_DIR}

	for chart in "${SOURCE_DIR}"/*; do
		helm package -d ${OUTPUT_DIR} "${chart}"
	done

	helm repo index ${OUTPUT_DIR} --url "https://$CHARTS_HOST"
	echo "Helm repository at ${OUTPUT_DIR} built successfully!"
}

publish() {
	rclone copy ${OUTPUT_DIR} "main:$CHARTS_S3_BUCKET/"
	echo "Helm repository files uploaded successfully!"
}

render_rclone_conf() {
	if [ -z "${CHARTS_S3_ACCESS_KEY}" ] || [ -z "${CHARTS_S3_SECRET_KEY}" ]; then
		echo "Please set CHARTS_S3_ACCESS_KEY and CHARTS_S3_SECRET_KEY env vars with S3-compatible credentials!"
		exit 1
	fi

	if [ -z "${CHARTS_S3_ENDPOINT}" ]; then
		echo "Please set CHARTS_S3_ENDPOINT to an S3-compatible endpoint URL!"
		exit 1
	fi

	config_path=$(rclone config file | tail -n 1)
	mkdir -p "$(dirname "${config_path}")"

cat <<EOF > "${config_path}"
[main]
type = s3
provider = ${CHARTS_S3_PROVIDER}
access_key_id = ${CHARTS_S3_ACCESS_KEY}
secret_access_key = ${CHARTS_S3_SECRET_KEY}
endpoint = ${CHARTS_S3_ENDPOINT}
acl = private
EOF
}

main "$@"
