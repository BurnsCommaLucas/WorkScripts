#!/bin/bash
# AUTHOR:
#	Lucas Burns
# FUNCTION:
#	Find active helm deployments based on pull requests with (state != active)
# 	and remove said helm deployments (maybe more?)
# USAGE: <see below for flags>
#	./kill-helm-deploys.sh <optional regex for helm>
#		e.g.
#		./kill-helm-deploys.sh
#			searches for helm deployments ending with "-pr-<number>"
#		./kill-helm-deploys.sh "banana-pr"
#			searches for helm deployments that contain "banana-pr"
# DEPENDENCIES:
#	helm, kubectl, bash >= 3.0, jq, wget, sed, getopts
# DOCS:
#	jq regex:		    https://stedolan.github.io/jq/manual/#RegularexpressionsPCRE
#	ADO Pull requests: 	https://docs.microsoft.com/en-us/rest/api/azure/devops/git/pull%20requests/get%20pull%20requests?view=azure-devops-rest-5.1

PROG_NAME=$0
HELM_REGEX="-pr-[0-9]+$"

#############################################
# getDeployNumber
#
# Pull a number from the end of a
#	deployment name
# Args:
#	- The deployment to get a number from
# Outputs:
#	- The number at the end of the
#		deployment name
#############################################
function getDeployNumber {
	echo ${1} | awk -F '-' '{print $NF}' | sed 's/[^0-9]*//'
}

#############################################
# itemInList
#
# Check if a list contains an item.
# Args:
#	- The item to check
#	- The expanded list to check against
# Outputs:
#	- 0 if item exists in list, else 1
#############################################
function itemInList {
	# Save first term to match against and shift it out of the args
	SEARCH=$1
	shift
	# For each subsequent arg, check if matches
	for ID in $@; do
		if [ ${ID} -eq ${SEARCH} ]; then
			echo 0
			return
		fi
	done
	echo 1
}

#############################################
# EX_MSG
#
# Print error statement if given, exit with
#   code if given
# Args:
#	- (OPTIONAL) The error message to print
#	- (OPTIONAL) The exit code to return
#############################################
function EX_MSG {
	echo "${1}Usage: ${PROG_NAME} -a <auth_token> -o <org_id> -p <project_id> -r <repo_id> (-x <helm_regex> -f <config_file>) (-d) (-h)"
	# Exit with code ${2}, or 0 if nothing in ${2}
	exit ${2:-0}
}

#   AVAILABLE FLAGS:
#       -a  Authorization token
#       -o  Organization name
#       -p  Project id
#       -r  Repository id
#       -x  Helm deployment regex
#           (still looks for PR number at
#           end of deployment name)
#       -d  Dry run mode, does everything but the uninstall step
#       -f  Get config from file
#           (command line args have precedence)
#           file should look like:
#               KEY=VAL
#               KEY=VAL
#               ...
while getopts "f:a:o:p:r:x:hd" FLAG; do
	case "${FLAG}" in
	a) AUTH_TOKEN="${OPTARG}" ;;
	o) ORG_NAME="${OPTARG}" ;;
	p) PROJECT_ID="${OPTARG}" ;;
	r) REPO_ID="${OPTARG}" ;;
	x) HELM_REGEX="${OPTARG}" ;;
	h) EX_MSG ;;
	d) DRY_RUN=1 ;;
	f)
		LINES=$(cat ${OPTARG})
		for LINE in $LINES; do
			KEY=$(awk -F '=' '{print $1}' <<<${LINE})
			VAL=$(awk -F '=' '{$1=""}{print $NF}' <<<${LINE})
			case "${KEY}" in
			# If using bash >= 4.0, this can be upgraded to a fallthrough
			AUTH_TOKEN) declare ${KEY}=${VAL} ;;
			ORG_NAME) declare ${KEY}=${VAL} ;;
			PROJECT_ID) declare ${KEY}=${VAL} ;;
			REPO_ID) declare ${KEY}=${VAL} ;;
			HELM_REGEX) declare ${KEY}=${VAL} ;;
			esac
		done
		;;
	esac
done

# We need all these params to send the pull request GET, see ADO Doc above
if [ -z $AUTH_TOKEN ] || [ -z $ORG_NAME ] || [ -z $PROJECT_ID ] || [ -z $REPO_ID ]; then
	EX_MSG "Missing one or more required parameters. " 1
fi

KUBE_CONTEXT=$(kubectl config current-context)

# List all helm deploys matching "${HELM_REGEX}"
echo =============================================
echo "Getting deploys matching '${HELM_REGEX}' from context ${KUBE_CONTEXT:-<context unavailable>}"
read -a DEPLOYS <<<$(helm list -o json |
	jq -r ".[].name | select(test(\"${HELM_REGEX}\"))")

# Create a list of the deploy *numbers* for printing
declare -a DEP_NUMS
for D in "${DEPLOYS[@]}"; do
	DEP_NUMS[${#DEP_NUMS[@]}]=$(getDeployNumber $D)
done

# List all pull requests (default is status == active)
echo "Getting pull requests with status 'active'"
read -a PULL_REQUESTS <<<$(wget --no-check-certificate -O- --quiet --method GET \
	--timeout=0 \
	--header "Authorization: Basic ${AUTH_TOKEN}" \
	--header 'Content-Type: application/json' \
	"https://dev.azure.com/${ORG_NAME}/${PROJECT_ID}/_apis/git/repositories/${REPO_ID}/pullRequests?api-version=5.1" |
	jq -r '.value[].pullRequestId')

# Pretty print results of listing
IFS_DEF=$IFS
IFS=,
echo -e "Found active helm deployments:\t${DEP_NUMS[*]:-None}"
echo -e "Found active pull requests:\t${PULL_REQUESTS[*]:-None}"
IFS=$IFS_DEF

# Check if each deployment has a matching PR
echo =============================================
echo Checking Helm Deployments:
for D in "${DEPLOYS[@]}"; do
	DEP_NUM=$(getDeployNumber "$D")
	if [ $(itemInList $DEP_NUM "${PULL_REQUESTS[@]}") == 0 ]; then
		echo Deployment $DEP_NUM has matching PR, ignoring
	else
		echo Deployment $DEP_NUM has no matching PR
		if [ $DRY_RUN ]; then
			echo DRY RUN: $DEP_NUM would be removed
		else
			helm uninstall $D
		fi
	fi
done
