SHELL := /bin/bash

.PHONY: encrypt-prod
encrypt-prod:
	@echo "Encrypting: `pbpaste | sed 's/\(..\).*$$/\1***/'`"
	@pbpaste | gcloud kms encrypt --plaintext-file=- --ciphertext-file=- --project=kubershmuber-prod-credentials --location=global --keyring=global-keyring --key=cloud-build-key | base64 -i - -o - | pbcopy
	@echo "Encrypted value is on the clipboard now!"
