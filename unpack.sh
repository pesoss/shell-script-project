#!/bin/bash

# I made this function for errors where I redirect the message given as first argument in std error (&2).
error_fn () {
	if [ "${#}" -ne 2 ]; then
		error_fn "Incorrect usage of error_fn" 100
	fi
	echo "${1}" >&2
	exit "${2}" 
}
# I made this function to check status coden is it != 0, and print error on std::error
status_code () {
	# checking number of arguments
	# first argument is status code
	# second argument is message to print on std::error
	if [ "${#}" -ne 2 ]; then
		error_fn "Incorrect usage of status_code" 100
	fi
	if [ "${1}" -ne 0 ]; then
		error_fn "${2}" 119
	fi
}

# I made this function to make my life easier
most_important_function () {
	if [ "${#}" -ne 7 ]; then
		error_fn "Incorrect usage of most_important_function!" 199
	fi

	file_to_extract="${1}" # first argument - "${1}" is (file) from while loop.
	tmp_dir_check="${2}" # second argument - "${2}" is (tmp_dir_xz/POSIX/gzip/bzip2/zip/rar)
	second_arg_of_script="${3}" # third argument - "${3}" is ($2), which is second argument of the script
	student_fn="${4}" # fourth argument - "${4}" is (correct_fn), which is the correct fn of a student
	extract_dir="${5}" # fifth argument - "${5}" is (tmp_dir_ext), which I use to extract files and find what I need
	file_format="${6}" # sixth argument - "${6}" is (xz/POSIX/gzip/bzip2/zip/rar), which let me know how to extract the file
	tmp_dir_check2="${7}" # seventh argument - "${7}" is ( (tmp_dir_zip/Rar)/(none) ), which I use only when extract zip and rar files

	regex_to_check_fn="[A-Z0-9]+"
	regex_to_check_txt_files="[a-zA-Z]+.txt"
	# check sixth argument "${6}" (file_format), is it format xz, POSIX, gzip, bzip2
	if [ "${file_format}" = "xz" ] || [ "${file_format}" = "POSIX" ] || [ "${file_format}" = "gzip" ] || [ "${file_format}" = "bzip2" ]; then

		if ( ! tar -xvf "${file_to_extract}" -C "${tmp_dir_check}" 2> /dev/null | sed 's|\./||' | egrep -q "^${regex_to_check_fn}/${regex_to_check_txt_files}$"); then

			mkdir "${second_arg_of_script}/${student_fn}"
			status_code "${?}" "Error: Can't make a diretori!"

			tar -xf "${file_to_extract}" -C "${extract_dir}" 2> /dev/null 1> /dev/null 
			status_code "${?}" "Error: Can't tar -xf the file of student ${student_fn}"

			find "${extract_dir}" -type f 2> /dev/null | xargs cp -r -t "${second_arg_of_script}/${student_fn}" 2> /dev/null
			nd=1

		else
			tar -xf "${file_to_extract}" -C "${extract_dir}" 2> /dev/null 1> /dev/null 
			status_code "${?}" "Error: Can't tar -xf the file of student ${student_fn}"

			find "${extract_dir}" -mindepth 1 -type d 2> /dev/null | xargs cp -r -t "${second_arg_of_script}" 2> /dev/null
		fi

		if ( ! tar -xvf "${file_to_extract}" -C "${tmp_dir_check}" 2> /dev/null | sed 's|\./||' | egrep -q "^${student_fn}/${regex_to_check_txt_files}"); then
			grd=1
		fi
	# check sixth argument "${6}" (file_format), is it format zip
	elif [ "${file_format}" = "zip" ]; then
		
		if ( ! unzip "${file_to_extract}" -d "${tmp_dir_check}" 2> /dev/null | egrep -q "${tmp_dir_check}/${regex_to_check_fn}/${regex_to_check_txt_files}"); then
			
			mkdir "${second_arg_of_script}/${student_fn}"
			status_code "${?}" "Error: Can't make a diretori!"

			unzip "${file_to_extract}" -d "${extract_dir}" 2> /dev/null 1> /dev/null
			status_code "${?}" "Error: Can't unzip the file of student ${student_fn}"

			find "${extract_dir}" -type f 2> /dev/null | xargs cp -r -t "${second_arg_of_script}/${student_fn}" 2> /dev/null
			nd=1

		else
			unzip "${file_to_extract}" -d "${extract_dir}" 2> /dev/null 1> /dev/null
			status_code "${?}" "Error: Can't unzip the file of student ${student_fn}"

			find "${extract_dir}" -mindepth 1 -type d 2> /dev/null | egrep "${5}/${regex_to_check_fn}$" | xargs cp -r -t "${second_arg_of_script}" 2> /dev/null 
		fi

		if ( ! unzip "${file_to_extract}" -d "${tmp_dir_check2}" 2> /dev/null | egrep -q "${student_fn}/${regex_to_check_txt_files}"); then
			grd=1
		fi
	# check sixth argument "${6}" (file_format), is it format rar
	elif [ "${file_format}" = "rar" ]; then
		
		if ( ! unrar x "${file_to_extract}" "${tmp_dir_check}" 2> /dev/null | tr -s ' ' | egrep -q " ${tmp_dir_check}/${regex_to_check_fn}/${regex_to_check_txt_files}" ); then
			
			mkdir "${second_arg_of_script}/${student_fn}"
			status_code "${?}" "Error: Can't make a diretori!"

			unrar x "${file_to_extract}" "${extract_dir}" 2> /dev/null 1> /dev/null
			status_code "${?}" "Error: Can't unrar the file of student ${student_fn}"

			find "${extract_dir}" -type f 2> /dev/null | xargs cp -r -t "${second_arg_of_script}/${student_fn}" 2> /dev/null
			nd=1

		else
			unrar x "${file_to_extract}" "${extract_dir}" 2> /dev/null 1> /dev/null
			status_code "${?}" "Error: Can't unrar the file of student ${student_fn}"

			find "${extract_dir}" -mindepth 1 -type d 2> /dev/null | xargs cp -r -t "${second_arg_of_script}" 2> /dev/null
		fi

		if ( ! unrar x "${file_to_extract}" "${tmp_dir_check2}" 2> /dev/null | tr -s ' ' | egrep -q "/${student_fn}/${regex_to_check_txt_files}" ); then
			grd=1
		fi
	# if format is wrong, print error on std::error
	else
		error_fn "Incorrect usege of most_important_function" 44
	fi		
}

# checking number of arguments, if it isn't == 4, print error message
if [ "${#}" -ne 4 ]; then
	error_fn "Error: Please enter 4 arguments!" 1
fi

# checking is first argument file, if it isn't, print error message
if [ ! -f "${1}" ]; then
	error_fn "Error: The first argument must be a existing file!" 2
fi

# checking is first argument zip file
if ( ! file "${1}" | egrep -q "^${1}: Zip archive data"); then
	error_fn "Error: Please enter zipped file" 3
fi

# checking second argument, is it existing file
if [ -e "${2}" ]; then
	error_fn "Error: The second argument must be a non-existing directory!" 4
fi

# checking third argument, is it existing file
if [ -e "${3}" ]; then
	error_fn "Error: The third argument must be a non-existing directory!" 5
fi

# checking fourth argument, is it existing file
if [ -e "${4}" ]; then
	error_fn "Error: The fourth argument must be a non-existing file" 6
fi

# I create two directories for second argument and for third argument
mkdir "${2}" "${3}"

# checking status code of mkdir
status_code "${?}" "Error: Can't create the directory!"

# I make file for fourth argument
touch "${4}"

# checking status code of touch
status_code "${?}" "Error: Can't create the file!"

# I create this tmp_dir to unzip first argument
tmp_dir=$(mktemp -d)

# unzipping first argument in tmp_dir and if there is some error, I redirect it to /dev/null
unzip -q "${1}" -d "${tmp_dir}" 2> /dev/null
status_code "${?}" "Error: Can't unzip the file given as first argument!"

while read file; do
	# make tmp dirs to extract files
	tmp_dir_xz=$(mktemp -d)
	tmp_dir_POSIX=$(mktemp -d)
	tmp_dir_gzip=$(mktemp -d)
	tmp_dir_bzip2=$(mktemp -d)
	tmp_dir_Zip=$(mktemp -d)
	tmp_dir_zip=$(mktemp -d)
	tmp_dir_rar=$(mktemp -d)
	tmp_dir_Rar=$(mktemp -d)
	tmp_dir_ext=$(mktemp -d)

	gri=0 # var for wrong name of file
	grf=0 # var for wrong format
	nd=0 # var for no directory
	grd=0 # var for wrong name of directory

	# get correct fn, file format as string (it contains file name and format given as name) and file name
	correct_fn=$(echo "${file}" | egrep -o "/[0-9].*-" | sed 's|/||' | sed 's/-//')
	file_format=$(echo "${file}" | awk -F '/' '{print $5}')
	file_name=$(echo "${file_format}" | awk -F '.' '{print $1}')

	# checking is file format named correcly
	if ( ! echo "${file_format}" | egrep -q ".tar.xz$"); then
		gri=1
	fi
	# Check real file format. We can have 7 options:
	# 1: if it is XZ format
	# 2: if it is POSIX format
	# 3: if it is gzip format
	# 4: if it is bzip2 format
	# 5: if it is zip format
	# 6: if it is rar format
	# 7: if it's wrong format and we have to "mv" it in third argument
	if (file "${file}" | egrep -q "^${file}: XZ compressed data"); then 
		most_important_function "${file}" "${tmp_dir_xz}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "xz" "none"
		
	elif (file "${file}" | egrep -q "^${file}: POSIX tar archive"); then
		grf=1
		most_important_function "${file}" "${tmp_dir_POSIX}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "POSIX" "none"
		
	elif (file "${file}" | egrep -q "^${file}: gzip compressed data"); then
		grf=1
		most_important_function "${file}" "${tmp_dir_gzip}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "gzip" "none"
		
	elif (file "${file}" | egrep -q "^${file}: bzip2 compressed data"); then
		grf=1
		most_important_function "${file}" "${tmp_dir_bzip2}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "bzip2" "none"
		
	elif (file "${file}" | egrep -q "^${file}: Zip archive data"); then
		grf=1
		most_important_function "${file}" "${tmp_dir_Zip}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "zip" "${tmp_dir_zip}"

	elif (file "${file}" | egrep -q "^${file}: RAR archive data"); then
		grf=1
		most_important_function "${file}" "${tmp_dir_rar}" "${2}" "${correct_fn}" "${tmp_dir_ext}" "rar" "${tmp_dir_Rar}"

	else
		mkdir "${3}/${correct_fn}"
		status_code "${?}" "Error: Can't make a directory!"
		cp -r "${file}" "${3}/${correct_fn}"
		status_code "${?}" "Error: Can't copy the file!"
		continue
	fi

	# checking is file name correct
	if [ ! "${correct_fn}" = "${file_name}" ]; then
		gri=1
		find "${2}" -type d -name "${file_name}" -exec mv {} "${2}/${correct_fn}" \; 2> /dev/null
	fi

	# write data in fourth argument
	echo "${correct_fn} ${gri} ${grf} ${nd} ${grd}" >> "${4}"

	# remove tmp dirs
	rm -rf "${tmp_dir_xz}" "${tmp_dir_POSIX}" "${tmp_dir_gzip}" "${tmp_dir_bzip2}" "${tmp_dir_Zip}" "${tmp_dir_zip}" "${tmp_dir_rar}" "${tmp_dir_ext}"

done < <(find "${tmp_dir}" -type f | sort -t '/' -k 4,4 -n)

rm -rf "${tmp_dir}"

echo "Successful!"
exit 0
