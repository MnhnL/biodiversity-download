# Read year from parameter
download_inat_observations() {
    local user=${1}
    local password=${2}
    local year=${3}
    
    rm cookiejar

    # Get an intial csrf-token
    local csrf_token=$(curl -s -c cookiejar 'https://inaturalist.lu/login' \
			   | sed -nr 's/.*name="csrf-token" content="(.*)".*/\1/p')
    # Log in
    echo "Logging in as '${user}'"
    csrf_token=$(curl -s -L -c cookiejar -b cookiejar 'https://inaturalist.lu/session' \
		      -F "authenticity_token=${csrf_token}" \
		      -F "user[email]=${user}" \
		      -F "user[password]=${password}" \
		      -F "user[remember_me]=0"\
		     | sed -nr 's/.*name="csrf-token" content="(.*)".*/\1/p')

    # Launch export creation job and extract job_id
    local job_id=$(curl -s -b cookiejar 'https://inaturalist.lu/flow_tasks' \
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
			--data-raw "year=${year}%26utf8=%E2%9C%93&observations_export_flow_task%5Binputs_attributes%5D%5B0%5D%5Bextra%5D%5Bquery%5D=quality_grade%3Dresearch%26captive%3Dfalse%26place_id%3D8147%26spam%3Dfalse&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_town_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_county_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_state_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_country_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin1_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin2_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_kingdom_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_phylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subphylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_class_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superorder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_order_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_suborder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_family_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_supertribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_tribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subtribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genus_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genushybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_species_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_hybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subspecies_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_variety_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_form_name%5D=0&commit=Create+Export" \
		       | python3 -c "import json, sys; print(json.load(sys.stdin).get('id', 'error'))")

			# -F "year=${year}" \
			# -F "utf8=✓" \
			# -F "observations_export_flow_task[inputs_attributes][0][extra][query]=quality_grade=research" \
			# -F "captive=false" \
			# -F "place_id=8147" \
			# -F "spam=false" \
			# -F "observations_export_flow_task[options][columns][id]=0" \
			# -F "observations_export_flow_task[options][columns][id]=1" \
			# -F "observations_export_flow_task[options][columns][observed_on_string]=0" \
			# -F "observations_export_flow_task[options][columns][observed_on_string]=1" \
			# -F "observations_export_flow_task[options][columns][observed_on]=0" \
			# -F "observations_export_flow_task[options][columns][observed_on]=1" \
			# -F "observations_export_flow_task[options][columns][time_observed_at]=0" \
			# -F "observations_export_flow_task[options][columns][time_observed_at]=1" \
			# -F "observations_export_flow_task[options][columns][time_zone]=0" \
			# -F "observations_export_flow_task[options][columns][time_zone]=1" \
			# -F "observations_export_flow_task[options][columns][user_id]=0" \
			# -F "observations_export_flow_task[options][columns][user_id]=1" \
			# -F "observations_export_flow_task[options][columns][user_login]=0" \
			# -F "observations_export_flow_task[options][columns][user_login]=1" \
			# -F "observations_export_flow_task[options][columns][user_name]=0" \
			# -F "observations_export_flow_task[options][columns][user_name]=1" \
			# -F "observations_export_flow_task[options][columns][created_at]=0" \
			# -F "observations_export_flow_task[options][columns][created_at]=1" \
			# -F "observations_export_flow_task[options][columns][updated_at]=0" \
			# -F "observations_export_flow_task[options][columns][updated_at]=1" \
			# -F "observations_export_flow_task[options][columns][quality_grade]=0" \
			# -F "observations_export_flow_task[options][columns][quality_grade]=1" \
			# -F "observations_export_flow_task[options][columns][license]=0" \
			# -F "observations_export_flow_task[options][columns][license]=1" \
			# -F "observations_export_flow_task[options][columns][url]=0" \
			# -F "observations_export_flow_task[options][columns][url]=1" \
			# -F "observations_export_flow_task[options][columns][image_url]=0" \
			# -F "observations_export_flow_task[options][columns][image_url]=1" \
			# -F "observations_export_flow_task[options][columns][sound_url]=0" \
			# -F "observations_export_flow_task[options][columns][sound_url]=1" \
			# -F "observations_export_flow_task[options][columns][tag_list]=0" \
			# -F "observations_export_flow_task[options][columns][tag_list]=1" \
			# -F "observations_export_flow_task[options][columns][description]=0" \
			# -F "observations_export_flow_task[options][columns][description]=1" \
			# -F "observations_export_flow_task[options][columns][num_identification_agreements]=0" \
			# -F "observations_export_flow_task[options][columns][num_identification_agreements]=1" \
			# -F "observations_export_flow_task[options][columns][num_identification_disagreements]=0" \
			# -F "observations_export_flow_task[options][columns][num_identification_disagreements]=1" \
			# -F "observations_export_flow_task[options][columns][captive_cultivated]=0" \
			# -F "observations_export_flow_task[options][columns][captive_cultivated]=1" \
			# -F "observations_export_flow_task[options][columns][oauth_application_id]=0" \
			# -F "observations_export_flow_task[options][columns][oauth_application_id]=1" \
			# -F "observations_export_flow_task[options][columns][place_guess]=0" \
			# -F "observations_export_flow_task[options][columns][place_guess]=1" \
			# -F "observations_export_flow_task[options][columns][latitude]=0" \
			# -F "observations_export_flow_task[options][columns][latitude]=1" \
			# -F "observations_export_flow_task[options][columns][longitude]=0" \
			# -F "observations_export_flow_task[options][columns][longitude]=1" \
			# -F "observations_export_flow_task[options][columns][positional_accuracy]=0" \
			# -F "observations_export_flow_task[options][columns][positional_accuracy]=1" \
			# -F "observations_export_flow_task[options][columns][private_place_guess]=0" \
			# -F "observations_export_flow_task[options][columns][private_place_guess]=1" \
			# -F "observations_export_flow_task[options][columns][private_latitude]=0" \
			# -F "observations_export_flow_task[options][columns][private_latitude]=1" \
			# -F "observations_export_flow_task[options][columns][private_longitude]=0" \
			# -F "observations_export_flow_task[options][columns][private_longitude]=1" \
			# -F "observations_export_flow_task[options][columns][public_positional_accuracy]=0" \
			# -F "observations_export_flow_task[options][columns][public_positional_accuracy]=1" \
			# -F "observations_export_flow_task[options][columns][geoprivacy]=0" \
			# -F "observations_export_flow_task[options][columns][geoprivacy]=1" \
			# -F "observations_export_flow_task[options][columns][taxon_geoprivacy]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_geoprivacy]=1" \
			# -F "observations_export_flow_task[options][columns][coordinates_obscured]=0" \
			# -F "observations_export_flow_task[options][columns][coordinates_obscured]=1" \
			# -F "observations_export_flow_task[options][columns][positioning_method]=0" \
			# -F "observations_export_flow_task[options][columns][positioning_method]=1" \
			# -F "observations_export_flow_task[options][columns][positioning_device]=0" \
			# -F "observations_export_flow_task[options][columns][positioning_device]=1" \
			# -F "observations_export_flow_task[options][columns][place_town_name]=0" \
			# -F "observations_export_flow_task[options][columns][place_county_name]=0" \
			# -F "observations_export_flow_task[options][columns][place_state_name]=0" \
			# -F "observations_export_flow_task[options][columns][place_country_name]=0" \
			# -F "observations_export_flow_task[options][columns][place_admin1_name]=0" \
			# -F "observations_export_flow_task[options][columns][place_admin2_name]=0" \
			# -F "observations_export_flow_task[options][columns][species_guess]=0" \
			# -F "observations_export_flow_task[options][columns][species_guess]=1" \
			# -F "observations_export_flow_task[options][columns][scientific_name]=0" \
			# -F "observations_export_flow_task[options][columns][scientific_name]=1" \
			# -F "observations_export_flow_task[options][columns][common_name]=0" \
			# -F "observations_export_flow_task[options][columns][common_name]=1" \
			# -F "observations_export_flow_task[options][columns][iconic_taxon_name]=0" \
			# -F "observations_export_flow_task[options][columns][iconic_taxon_name]=1" \
			# -F "observations_export_flow_task[options][columns][taxon_id]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_id]=1" \
			# -F "observations_export_flow_task[options][columns][taxon_kingdom_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_phylum_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_subphylum_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_superclass_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_class_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_subclass_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_superorder_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_order_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_suborder_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_superfamily_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_family_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_subfamily_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_supertribe_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_tribe_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_subtribe_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_genus_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_genushybrid_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_species_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_hybrid_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_subspecies_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_variety_name]=0" \
			# -F "observations_export_flow_task[options][columns][taxon_form_name]=0" \
			# -F "commit=Create+Export" \


    #job_id=$(curl -s 'https://inaturalist.lu/flow_tasks' -b cookiejar -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H "X-CSRF-Token: ${csrf_token}" -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://inaturalist.lu' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-GPC: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw "year=${year}%26utf8=%E2%9C%93&observations_export_flow_task%5Binputs_attributes%5D%5B0%5D%5Bextra%5D%5Bquery%5D=quality_grade%3Dresearch%26captive%3Dfalse%26place_id%3D8147%26spam%3Dfalse&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bid%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on_string%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bobserved_on%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_observed_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btime_zone%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_login%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Buser_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcreated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bupdated_at%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bquality_grade%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blicense%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Burl%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bimage_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bsound_url%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btag_list%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bdescription%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_agreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bnum_identification_disagreements%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcaptive_cultivated%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Boauth_application_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blatitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Blongitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_place_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_latitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bprivate_longitude%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpublic_positional_accuracy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bgeoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_geoprivacy%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcoordinates_obscured%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_method%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bpositioning_device%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_town_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_county_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_state_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_country_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin1_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bplace_admin2_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bspecies_guess%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bscientific_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Bcommon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Biconic_taxon_name%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_id%5D=1&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_kingdom_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_phylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subphylum_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_class_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subclass_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superorder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_order_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_suborder_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_superfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_family_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subfamily_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_supertribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_tribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subtribe_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genus_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_genushybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_species_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_hybrid_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_subspecies_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_variety_name%5D=0&observations_export_flow_task%5Boptions%5D%5Bcolumns%5D%5Btaxon_form_name%5D=0&commit=Create+Export" | python3 -c "import json, sys; print(json.load(sys.stdin).get('id', 'error'))")

    echo "Created job with id: '$job_id'. Polling for readiness..."

    local finished_at=None
    while [ "${finished_at}" = "None" ]; do
	finished_at=$(curl -s -b cookiejar "https://inaturalist.lu/flow_tasks/${job_id}/run.json" \
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
			  | python3 -c "import json, sys; print(json.load(sys.stdin).get('finished_at', 'error'))")
	echo "Finished at: $finished_at"
	sleep 20
    done

    curl -v -s -b cookiejar "https://inaturalist.lu/flow_tasks/${job_id}/run.json" \
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
	 -H 'Cache-Control: no-cache' > download_inat_status.json

    local output_id=$(cat download_inat_status.json | python3 -c "import json, sys; print(json.load(sys.stdin).get('outputs', 'error')[0].get('id', 'error'))")
    local output_id=$(cat download_inat_status.json | python3 -c "import json, sys; print(json.load(sys.stdin).get('outputs', 'error')[0].get('file_file_name', 'error'))")
    local download_url="https://inaturalist.lu/attachments/flow_task_outputs/${output_id}/${file_file_name}"
    echo "Downloading archive from ${download_url}..."
    curl -s -b cookiejar "${download_url}" -o "inaturalist_${year}.zip"
    rm cookiejar download_inat_status.json
}

