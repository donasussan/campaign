#!/bin/bash

generate_data() {

    

    k=$((k+1))

    campaign_ID=$k

    activity=$((1 + RANDOM % 6))

    activity_date="2023-01-01"

    percent=$((1 + RANDOM % 100))

    case $activity in

    1)

        

        ;;

    2)

        nested_array=(1 3)

        ;;

    3)

        nested_array=(1 3 4)

        ;;

    4)

        nested_array=(1 3 4 7)

        ;;

    5)

        if (($percent <= 96)); then

        nested_array=(1)

        else

            flag=0

            if (($percent == 97)); then

                nested_array=(1 3 4 5)

            elif (($percent == 98)); then

                nested_array=(1 3 4 6)

            elif (($percent == 99)); then

                nested_array=(1 3 4 5 6)

            else

                nested_array=(2)

            fi

        fi

        ;;

    6)

        if (($percent < 20)); then

            nested_array=(1 3 3)

        elif (($percent < 40)); then

            nested_array=(1 3 3 4)

        elif (($percent < 60)); then

            nested_array=(1 3 4 3)

        elif (($percent < 80)); then

            nested_array=(1 3 4 3 4)

        elif (($percent < 90)); then

            nested_array=(1 3 4 7 3)

        else

            nested_array=(1 3 4 7 3 4)

        fi

        ;;

    *)

        echo "Unknown key: $activity"

        ;;

esac

    for ((z=0; z<${#nested_array[@]}; z++)); do

        array_value="${nested_array[$z]}"

        ind_activity_date=$(date -d "$activity_date + $((z+1)) days" +%Y-%m-%d)

        activity_string+="(@p_id, $campaign_ID, $array_value, \"$ind_activity_date\"),"

    done

    

    if [[ $campaign_ID -eq 100  || $flag -eq 0   ]]; then

        activity_string="${activity_string%,}"

        echo "$activity_string"

        echo "$flag"

        activity_string=''

    else

        generate_data

    fi

}

 

 

start_time=$(date +%s%3N)

count=1

batch_size=1

nested_array=()

j=0

sql_query=''

for ((i=1; i<=$count; i++)); do

    k=0

    flag=1

    name="Name$i"

    email="name$i@example.com"

    dob=$(date -d "$((RANDOM % 36525)) days ago" +%Y-%m-%d)

    country="Country$i"

    city="City$i"

    json="{\"dob\":\"$dob\",\"country\":\"$country\",\"city\":\"$city\"}"

    generate_data_output=$(generate_data)

    flag_val=$(echo "$generate_data_output" | tail -n 1)

    activity_values=$(echo "$generate_data_output" | head -n -1)

 

    #PROCEDURE          CALL InsertValues3('$name','$email','$flag','$json','$activity_string');

    sql_query+="CALL InsertValues3('$name','$email','$flag_val','$json','$activity_values');"

    j=$((j+1))

    result=''

    activity_string=''

 

    if [[ $j -gt $batch_size || $i -eq $count ]]; then

 

#          mysql --defaults-file=~/.my.cnf -D Task_mysql <<EOF

 

#         START TRANSACTION;

 

#         $sql_query

 

#         COMMIT;

 

# EOF

 

        end_time=$(date +%s%3N)

        execution_time=$((end_time - start_time))

        echo "batch execution time: $execution_time milliseconds"

        j=0

        activity_date=$(date -d "$activity_date + 1 months" +%Y-%m-%d)

        sql_query=''

    fi

done

end_time=$(date +%s%3N)

execution_time=$((end_time - start_time))

echo "Script execution time: $execution_time milliseconds"

 

 