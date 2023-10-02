# Default target when you run 'make' without specifying a target.
# This lists all available targets.
help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z0-9_-]+:/ { \
			print "  " substr($$1, 1, length($$1)-1) " : " $$2; \
		}' $(MAKEFILE_LIST) | \
		column -s ":" -t

terraform-apply-changes:
	terraform plan \
    && terraform apply --auto-approve

terraform-remove-changes:
	terraform destroy --auto-approve

list-s3-buckets:
	aws s3api list-buckets
