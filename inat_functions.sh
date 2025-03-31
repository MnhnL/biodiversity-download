download_inat_observations() {
    local user=${1}
    local password=${2}
    local date_start=${3}
    local date_end=${4}

    local poll_secs=10

    local output_root="inaturalist_${date_start}-${date_end}"
    local archive_path="/tmp/${output_root}.zip"
    local csv_path="${output_root}.csv"
    local inaturalist_url="https://inaturalist.lu"
    local cookiejar_path="/tmp/inat_cookiejar"

    if [ "${5}" != "" ]; then
	local target_file_name=${5}
    else
	local target_file_name=${csv_path}
    fi
    
    if [ -f ${cookiejar_path} ]; then
	rm ${cookiejar_path}
    fi

    # Get an intial csrf-token
    local csrf_token=$(curl -s -c ${cookiejar_path} "${inaturalist_url}/login" \
			   | sed -nr 's/.*name="csrf-token" content="(.*)".*/\1/p')
    # Log in
    echo "Logging in as '${user}'"
    csrf_token=$(curl -s -L -c ${cookiejar_path} -b ${cookiejar_path} "${inaturalist_url}/session" \
		      -F "authenticity_token=${csrf_token}" \
		      -F "user[email]=${user}" \
		      -F "user[password]=${password}" \
		      -F "user[remember_me]=0"\
		     | sed -nr 's/.*name="csrf-token" content="(.*)".*/\1/p')


    # Launch export creation job and extract job_id
    local place_id=137976 # Luxembourg (buffered)
    local query="\
quality_grade%3Dresearch%26\
identifications%3Dany%26\
captive%3Dfalse%26\
geoprivacy%3Dopen%26\
taxon_geoprivacy%3Dopen%26\
place_id%3D${place_id}%26\
spam%3Dfalse"

    if [ "$date_start" != "" ]; then
	query="${query}%26d1%3D${date_start}"
    fi
    if [ "$date_end" != "" ]; then
	query="${query}%26d2%3D${date_end}"
    fi

    local query_raw="utf8=%E2%9C%93&observations_export_flow_task%5Binputs_attributes%5D%5B0%5D%5Bextra%5D%5Bquery%5D=${query}&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_town_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_county_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_state_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_country_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin1_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin2_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_kingdom_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_phylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subphylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_class_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superorder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_order_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_suborder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_family_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_supertribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_tribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subtribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genus_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genushybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_species_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_hybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subspecies_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_variety_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_form_name%5D=0&commit=Create+Export"
    local job_id=$(curl -s -b ${cookiejar_path} "${inaturalist_url}/flow_tasks" \
			-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0' \
			-H 'Accept: application/json, text/javascript, */*; q=0.01' \
			-H "X-CSRF-Token: ${csrf_token}" \
			-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
			-H 'X-Requested-With: XMLHttpRequest' \
			-H 'Origin: https://inaturalist.lu' \
			-H 'Connection: keep-alive' \
			-H 'Sec-Fetch-Dest: empty' \
			-H 'Sec-Fetch-Mode: cors' \
			-H 'Sec-Fetch-Site: same-origin' \
			-H 'Sec-GPC: 1' \
			-H 'Pragma: no-cache' \
			-H 'Cache-Control: no-cache' \
			--data-raw "${query_raw}" | python3 -c "import json, sys; print(json.load(sys.stdin).get('id', 'error'))")

    if [ $job_id = 'error' ]; then
	echo "Can't get job_id. Exiting."
	return
    fi

    echo "Created job with id: '$job_id'. Polling for readiness..."

    local finished_at=None
    while [ "${finished_at}" == "None" ]; do
	finished_at=$(curl -s -b ${cookiejar_path} "${inaturalist_url}/flow_tasks/${job_id}/run.json" \
			   -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0' \
			   -H 'Accept: application/json, text/javascript, */*; q=0.01' \
			   -H 'Accept-Language: en-US,en;q=0.5' \
			   -H 'Accept-Encoding: gzip, deflate, br' \
			   -H 'Referer: https://inaturalist.lu/observations/export?verifiable=&page=1&spam=false&place_id=8147&user_id=&project_id=&swlng=&swlat=&nelng=&nelat=&lat=&lng=&radius=&quality_grade=research' \
			   -H 'X-CSRF-Token: ${csrf_token}' \
			   -H 'X-Requested-With: XMLHttpRequest' \
			   -H 'Connection: keep-alive' \
			   -H 'Sec-Fetch-Dest: empty' \
			   -H 'Sec-Fetch-Mode: cors' \
			   -H 'Sec-Fetch-Site: same-origin' \
			   -H 'Sec-GPC: 1' \
			   -H 'Pragma: no-cache' \
			   -H 'Cache-Control: no-cache' \
			  | python3 -c "import json, sys; print(json.load(sys.stdin).get('finished_at', 'error'))" 2> /dev/null)
	echo "Download not ready yet. Waiting for ${poll_secs}s..."
	sleep $poll_secs
    done

    curl -s -b ${cookiejar_path} "${inaturalist_url}/flow_tasks/${job_id}/run.json" \
	 -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0' \
	 -H 'Accept: application/json, text/javascript, */*; q=0.01' \
	 -H 'Accept-Language: en-US,en;q=0.5' \
	 -H 'Accept-Encoding: gzip, deflate, br' \
	 -H 'Referer: https://inaturalist.lu/observations/export' \
	 -H 'X-CSRF-Token: ${csrf_token}' \
	 -H 'X-Requested-With: XMLHttpRequest' \
	 -H 'Connection: keep-alive' \
	 -H 'Sec-Fetch-Dest: empty' \
	 -H 'Sec-Fetch-Mode: cors' \
	 -H 'Sec-Fetch-Site: same-origin' \
	 -H 'Sec-GPC: 1' \
	 -H 'Pragma: no-cache' \
	 -H 'Cache-Control: no-cache' > download_inat_status.json

    local output_id=$(cat download_inat_status.json | python3 -c "import json, sys; print(json.load(sys.stdin).get('outputs', 'error')[0].get('id', 'error'))")
    local file_file_name=$(cat download_inat_status.json | python3 -c "import json, sys; print(json.load(sys.stdin).get('outputs', 'error')[0].get('file_file_name', 'error'))")
    local download_url="https://inaturalist.lu/attachments/flow_task_outputs/${output_id}/${file_file_name}"

    echo "Downloading archive from '${download_url}'..."
    
    curl -s -b ${cookiejar_path} "${download_url}" -o "${archive_path}"

    echo "Unpacking to ${csv_path}"
    local zip_csv_path="observations-${job_id}.csv"
    unzip "${archive_path}" "${zip_csv_path}"
    rm "${archive_path}"
    mv "${zip_csv_path}" "${csv_path}"

    sleep 30

    echo "Deleting download on server..."
    curl -s -b ${cookiejar_path} "https://inaturalist.lu/flow_tasks/${job_id}" \
	 -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0' \
	 -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
	 -H 'Accept-Language: en-US,en;q=0.5' \
	 -H 'Accept-Encoding: gzip, deflate, br' \
	 -H 'Content-Type: application/x-www-form-urlencoded' \
	 -H 'Referer: https://inaturalist.lu/observations/export?flow_task_id=${job_id}' \
	 -H 'X-Requested-With: XMLHttpRequest' \
	 -H 'Connection: keep-alive' \
	 -H 'Sec-Fetch-Dest: empty' \
	 -H 'Sec-Fetch-Mode: cors' \
	 -H 'Sec-Fetch-Site: same-origin' \
	 -H 'Sec-GPC: 1' \
	 -H 'Pragma: no-cache' \
	 -H 'Cache-Control: no-cache' \
	 -F "authenticity_token=${csrf_token}" -F '_method=delete'

    rm ${cookiejar_path} download_inat_status.json
    echo "DONE!"
}

