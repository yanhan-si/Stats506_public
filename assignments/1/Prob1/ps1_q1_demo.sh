#!usr/bin/env zsh

# Stats 506, Fall 2020
#
# Include a title and descriptive header with the same elements described
# in `psX_template.R`
#
# Author(s): Yanhan Si
# Updated: September 23, 2020
# 79: -------------------------------------------------------------------------

# download data for the problem set if needed: --------------------------------
## download only if the file doesn't exist
while read col1 col2
do
    file=DEMO_$col2.XPT
    if [ ! -f $file ]; then
    url=https://wwwn.cdc.gov/Nchs/Nhanes/$col1/DEMO_$col2.XPT
    wget $url
    fi
done < nhanes_files.txt

## converts xpt files to csv
# run supporting scripts if they aren't sourced in the Rmarkdown file: --------

if [ ! -f "DEMO_G.csv" ]; then
 Rscript ./p1b.R
fi

# extracts the following columns: id (SEQN), dentition exam status (OHDDESTS),
# tooth counts (OHXxxTC), and coronal caries (OHXxxCTC) into files short.csv

while read col1 col2
do
    file=short_DEMO_$col2.csv
    if [ ! -f $file ]; then
    zsh cutnames.sh DEMO_$col2.csv "SEQN|RIDAGYR|RIDRETH3|DMDEDUC2|DMDMARTL|RIDSTATR|SDMVPSU|SDMVSTRA|WTMEC2YR|WTINT2YR" | tail -n+2 > $file
    fi
done < nhanes_files.txt

## appends all years into a single file nhanes_ohxden.csv
#total_file="nhanes_demo.csv"

## first check whether the columns match
header_file="header_DEMO.txt"

if [ ! -f "$header_file" ]; then
    while read col1 col2
    do
        file=short_DEMO_$col2.csv
        < $file head -n1  >> "$header_file"
    done < nhanes_files.txt
fi

zsh ex_check_dup_lines.sh $header_file

# Append all the years into a single file
file_name="nhanes_demo.csv"

if [ ! -f "$file_name" ]; then
    < short_DEMO_G.csv head -n1  > "$file_name"
    while read col1 col2
    do
        file=short_DEMO_$col2.csv
        < $file tail -n+2  >> "$file_name"
    done < nhanes_files.txt
fi

# render the problem set markdown file: ---------------------------------------
#Rscript -e 'rmarkdown::render("psX_template.Rmd")'

## or for documents to be created with "spin"
#Rscript -e 'knitr::spin("p1.R", knit = FALSE)'
#Rscript -e 'rmarkdown::render("psX_spin_template.Rmd")' && \
#    rm psX_spin_template.Rmd

# 79: -------------------------------------------------------------------------
