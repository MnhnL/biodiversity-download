latest_clb_dataset() {
    local from_dataset="${1}"
    local latest_dataset_key=$(curl -s -X 'GET' 'https://api.checklistbank.org/dataset?offset=0&limit=1&releasedFrom=3&reverse=true' -H 'accept: application/json' | python3 -c 'import json, sys; print(json.load(sys.stdin)["result"][0]["key"])')
    echo $latest_dataset_key
}

download_clb_checklist() {
    local dataset_key=${1}
    local download_path=${2}
    local extraction_path=${3}
    local job_id=$(curl -s -n -X POST "https://api.checklistbank.org/dataset/${dataset_key}/export" --json '{"bareNames": false, "excel": false, "format": "coldp", "synonyms": true}')
    local file_url="https://download.checklistbank.org/job/${job_id:1:2}/${job_id:1:-1}.zip"
    mkdir -p "$(dirname ${download_path})"
    curl "${file_url}" -o "${download_path}"
    mkdir -p "${extraction_path}"
    unzip "${download_path}" -d "${extraction_path}"
}

download_clb_match() {
    local source_key=${1}
    local destination_key=${2}
    local download_path=${3}
    local extraction_path=${4}
    local job_key=$(curl -s -n -X POST "https://api.checklistbank.org/dataset/${destination_key}/match/nameusage/job?sourceDatasetKey=${source_key}" | python3 -c "import json, sys; print(json.load(sys.stdin)['key'])")
    local status=waiting
    while [ "${status}" = "waiting" -o "${status}" = "running" ]; do
	local status=$(curl -s -n "https://api.checklistbank.org/job/${job_key}" | python3 -c "import json, sys; print(json.load(sys.stdin)['status'])")
	local download_url=$(curl -s -n "https://api.checklistbank.org/job/${job_key}" | python3 -c "import json, sys; print(json.load(sys.stdin)['result']['download'])")
	echo $status $job_key $download_url
	if [ "${status}" != "waiting" -a "${status}" != "running" ]; then
	     break;
	fi
	sleep 20
    done

    mkdir -p "$(dirname ${download_path})"
    curl "${download_url}" -o "${download_path}"
    mkdir -p "${extraction_path}"
    unzip "${download_path}" -d "${extraction_path}"
}
