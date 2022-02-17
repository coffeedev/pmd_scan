#!/bin/bash

/usr/local/lib/pmd/bin/run.sh pmd --version
export fullDate=$(date +%Y-%m-%d-%R)
export result_file=/opt/atlassian/pipelines/agent/build/codestyle_pmdresult_$fullDate
export pmdresults1=$result_file.xml
export pmdresults2=$result_file.html

echo "Scanning code now..."

/usr/local/lib/pmd/bin/run.sh pmd -d force-app -R pmd-scan/apex_codestyle_rulesets.xml -f xml --fail-on-violation false -r $pmdresults1 > /dev/null 2>&1
/usr/local/lib/pmd/bin/run.sh pmd -d force-app -R pmd-scan/apex_codestyle_rulesets.xml -f summaryhtml --fail-on-violation false -r $pmdresults2 > /dev/null 2>&1

echo -e "Scanning done.\n"

results1=$(grep -s -o -i 'priority="1"' $pmdresults1 | wc -l)
results2=$(grep -s -o -i 'priority="2"' $pmdresults1 | wc -l)
results3=$(grep -s -o -i 'priority="3"' $pmdresults1 | wc -l)

echo "Issues found"
echo -e "-----------------------\n"

echo "Priority 1 : "$results1
echo "Priority 2 : "$results2
echo "Priority 3 : "$results3