#!/bin/bash

registered_users_file="RegisteredUsers.txt"
psychological_test_file="PsychologicalTest.txt"

echo "Welcome to the Mental Health Application!"

while true; do
    echo "Please choose an option:"
    echo "1. Sign up"
    echo "2. Log in"
    echo "3. Exit"
    read -p "Enter your choice (1/2/3): " choice

    if [[ $choice == 1 ]]; then
        read -p "Enter your name: " name
        read -p "Enter your phone number: " phone_number
        echo "$name $phone_number" >> "$registered_users_file"
        echo "Sign up successful!"

    elif [[ $choice == 2 ]]; then
        read -p "Enter your phone number: " phone_number
        user_info=$(grep "$phone_number" "$registered_users_file" 2>/dev/null)

        if [[ -z $user_info ]]; then
            echo "User not found. Please sign up first."
            continue
        fi

        name=$(echo "$user_info" | awk '{print $1}')
        echo "Hi $name!"

        while true; do
            echo "1. Perform psychological test"
            echo "2. Show old tests"
            echo "3. Exit"
            read -p "Enter your choice (1/2/3): " test_choice

            if [[ $test_choice == 1 ]]; then
        echo "Please answer the following questions with yes or no:"

                questions=("Q1: Do you often feel anxious or stressed? " "Q2: Do you have difficulty sleeping or staying focused? " "Q3: Do you feel sad or hopeless most of the time?" "Q4: Have you lost interest in activities you used to enjoy? " "Q5: Do you experience mood swings or sudden changes in energy levels?  " "Q6: Do you have difficulty controlling your thoughts or behavior? " "Q7: Do you hear voices or see things that others don't? " "Q8: Do you feel like your thoughts are racing or you can't slow down? ")
        answers=()

        yes_count=0
        no_count=0

        for ((i=0; i<8; i++)); do
            read -p "${questions[$i]} [yes/no]: " answer
            answers+=("$answer")

            if [[ "$answer" == "yes" ]]; then
                yes_count=$((yes_count + 1))
            elif [[ "$answer" == "no" ]]; then
                no_count=$((no_count + 1))
            else
                echo "Invalid answer. Please answer 'yes' or 'no'."
                i=$((i-1))
                continue
            fi
        done

        echo "$phone_number ${answers[@]}" >> "$psychological_test_file"
        echo "Test completed."

        echo "Yes: $yes_count"
        echo "No: $no_count"

                if [[ $yes_count -eq 0 ]]; then
                    echo "You are in good health and do not suffer from anything."
                elif [[ $yes_count -eq 1 ]]; then
                    echo "You suffer from mild anxiety and it can be treated easily."
                elif [[ $yes_count -ge 2 && $yes_count -le 4 ]]; then
                    echo "You may suffer from mild to moderate depression."
                elif [[ $yes_count -ge 5 && $yes_count -le 6 ]]; then
                    echo "You have deep depression."
                elif [[ $yes_count -ge 7 && $yes_count -le 8 ]]; then
                    echo "You suffer from bipolar disorder or schizophrenia."
                fi

                read -p "Do you want us to show you some solutions? [yes/no]: " solution_choice

                if [[ $solution_choice == "yes" ]]; then
                    case $yes_count in
                        0)
                            echo "No specific solutions recommended."
                            ;;
                        1)
                            echo "Solutions for mild anxiety:"
                            echo "- Practice relaxation techniques such as deep breathing and meditation."
                            echo "- Engage in regular physical exercise."
                            echo "- Maintain a balanced diet and get enough sleep."
                            ;;
                        2|3|4)
                            echo "Solutions for mild to moderate depression:"
                            echo "- Seek professional help from a therapist or counselor."
                            echo "- Engage in regular exercise and physical activities."
                            echo "- Practice stress management techniques."
                            ;;
                        5|6)
                            echo "Solutions for deep depression:"
                            echo "- Seek immediate professional help from a mental health specialist."
                            echo "- Consider medication and therapy options."
                            echo "- Reach out to friends and family for support."
                            ;;
                        7|8)
                            echo "Solutions for bipolar disorder or schizophrenia:"
                            echo "- Urgently seek professional help from a psychiatrist."
                            echo "- Follow the prescribed treatment plan."
                            echo "- Build a strong support network."
                            ;;
                    esac
                fi

            elif [[ $test_choice == 2 ]]; then
                user_tests=$(grep "$phone_number" "$psychological_test_file" 2>/dev/null)

                if [[ -z $user_tests ]]; then
                    echo "No previous tests found."
                else
                    echo "Previous tests:"
                    echo "$user_tests"
                fi

            elif [[ $test_choice == 3 ]]; then
                echo "Thank you for using the Mental Health Application. Goodbye!"
                break

            else
                echo "Invalid choice. Please try again."
            fi

            break
        done

    elif [[ $choice == 3 ]]; then
        echo "Thank you for using the Mental Health Application. Goodbye!"
        break
    else
        echo "Invalid choice. Please try again."
    fi
done
