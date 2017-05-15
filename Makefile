# the filepath to this repository
REPO_PATH := https://StackPointCloud.gitlab.io/charts

# generare helm chart archives
gen:
	./.scripts/gen_packages.sh

# index packaged charts
index:
	helm repo index --url $(REPO_PATH) ./docs

all: gen index
