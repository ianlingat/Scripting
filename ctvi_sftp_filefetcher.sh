#!/bin/bash
#Christian Arth Lingat

# define Log file directory and the log files name with $DATE included
#Date
DATE=`date +"%Y-%m-%d"`
LOG_FILE_AND_DIRECTORY="/tmp/sftp_fetch.sh_$DATE.log"

#Date Start
DATE_START=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE_START ===============================================START OF PROCESS===============================================" >> ${LOG_FILE_AND_DIRECTORY}

# define SFTP server details
SFTP_SERVER="172.1.86.4"
SFTP_USERNAME="root"

# define remote and local directories
REMOTE_DIR="/tmp/CIC_Encrypted_Files_CTVI/"
ENCRYPTED_DIR="/tmp/CTVI_Fetched_Encrypted_Files/Encrypted/"

# set the path to the directory where the decrypted files should be saved
DECRYPTED_DIR="/tmp/CTVI_Fetched_Encrypted_Files/Decrypted/"

# set the path to the directory where the encrypted files should be moved after decryption
MOVED_ENCRYPTED_DIR="/tmp/CTVI_Fetched_Encrypted_Files/Processed/"

# get list of files on the remote server
REMOTE_FILES=$(sftp ${SFTP_USERNAME}@${SFTP_SERVER} << EOF
  cd ${REMOTE_DIR}
  ls
  bye
EOF
)

REMOTE_FILE_LIST=`echo $REMOTE_FILES | sed 's/sftp> cd \/tmp\/CIC_Encrypted_Files_CTVI\/ sftp> ls //g' | sed 's/ sftp> bye//g'`

# loop through each file on the remote server
for REMOTE_FILE in $REMOTE_FILE_LIST
do
#Date and time Variable
DATE_TIME_REMOTE_FILE=`date +"%Y-%m-%d %H:%M:%S"`

  # check if the file already exists on the local server
  if [ -e "${MOVED_ENCRYPTED_DIR}${REMOTE_FILE}" ]
  then
    echo "$DATE_TIME_REMOTE_FILE - File ${REMOTE_FILE} already exists on local server. Skipping." >> ${LOG_FILE_AND_DIRECTORY}
  else
    # fetch the file from the remote server
    sftp ${SFTP_USERNAME}@${SFTP_SERVER} << EOF
      cd ${REMOTE_DIR}
      get ${REMOTE_FILE} ${ENCRYPTED_DIR}
      bye
EOF
    # check if the file was successfully fetched
    if [ -e "${ENCRYPTED_DIR}${REMOTE_FILE}" ]
    then
      echo "$DATE_TIME_REMOTE_FILE File ${REMOTE_FILE} successfully fetched from SFTP server and saved to ${ENCRYPTED_DIR}." >> ${LOG_FILE_AND_DIRECTORY}
    else
      echo "$DATE_TIME_REMOTE_FILE Failed to fetch file ${REMOTE_FILE} from SFTP server." >> ${LOG_FILE_AND_DIRECTORY}
    fi
  fi
done

#Date and time Variable
DATE_TIME_FETCHING_FILE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE_TIME_FETCHING_FILE Done fetching and checking of files." >> ${LOG_FILE_AND_DIRECTORY}


# loop through each encrypted file in the encrypted directory
for ENCRYPTED_FILE in ${ENCRYPTED_DIR}*
do
#Date and time Variable
DATE_TIME_ENCRYPTING_FILE=`date +"%Y-%m-%d %H:%M:%S"`

  # decrypt the file using the GPG command and save it to the decrypted directory
  gpg --output ${DECRYPTED_DIR}$(basename ${ENCRYPTED_FILE} .gpg) --decrypt ${ENCRYPTED_FILE}

  # check if the file was successfully decrypted and saved
  if [ -e "${DECRYPTED_DIR}$(basename ${ENCRYPTED_FILE} .gpg)" ]
  then
    echo "$DATE_TIME_ENCRYPTING_FILE File $(basename ${ENCRYPTED_FILE}) successfully decrypted and saved to ${DECRYPTED_DIR}." >> ${LOG_FILE_AND_DIRECTORY}

    # copy the original encrypted file to the encrypted directory
    mv -v ${ENCRYPTED_FILE} ${MOVED_ENCRYPTED_DIR}

    # check if the file was successfully moved
    if [ -e "${MOVED_ENCRYPTED_DIR}$(basename ${ENCRYPTED_FILE})" ]
    then
      echo "$DATE_TIME_ENCRYPTING_FILE File $(basename ${ENCRYPTED_FILE}) successfully moved to ${MOVED_ENCRYPTED_DIR}." >> ${LOG_FILE_AND_DIRECTORY}
    else
      echo "$DATE_TIME_ENCRYPTING_FILE Failed to move file $(basename ${ENCRYPTED_FILE}) to ${MOVED_ENCRYPTED_DIR}." >> ${LOG_FILE_AND_DIRECTORY}
    fi

  else
    echo "$DATE_TIME_ENCRYPTING_FILE Failed to decrypt files there are no latest files to decrypt." >> ${LOG_FILE_AND_DIRECTORY}
  fi
done

#Date and time Variable
DATE_TIME_ENCRYPTING_DONE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE_TIME_ENCRYPTING_DONE Done decrypting files and moving encrypted files." >> ${LOG_FILE_AND_DIRECTORY}

#Date Start
DATE_END=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE_END ================================================END OF PROCESS================================================" >> ${LOG_FILE_AND_DIRECTORY}
