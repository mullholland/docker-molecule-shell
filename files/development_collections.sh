#!/bin/bash

INFILE=${1}
OUTFILE=${2}

echo "Build collections.yml -> ${OUTFILE} from ${INFILE}"
echo "---" >${OUTFILE}
echo "collections:" >>${OUTFILE}

# build collections yaml
while read collection; do
  echo "  - name: ${collection}"
  echo "  - name: ${collection}" >>${OUTFILE}
  echo "    source: https://galaxy.ansible.com" >>${OUTFILE}

done < "${INFILE}"
