#!/usr/bin/python3
'''
Python script that, using this REST API
`https://jsonplaceholder.typicode.com/todos/`, for a given employee ID,
returns information about his/her TODO list progress.
'''
import requests
from sys import argv, exit

if __name__ == "__main__":
    if len(argv) != 2 or not argv[1].isdigit():
        exit(1)
    try:
        EMPLOYEE_ID = int(argv[1])
        BASE_URL = 'https://jsonplaceholder.typicode.com/'
        USER_URL = f"{BASE_URL}users/{EMPLOYEE_ID}"
        TODOS_URL = f"{BASE_URL}/todos?userId={EMPLOYEE_ID}"
        EMPLOYEE_NAME = requests.get(USER_URL).json()["name"]
        NUMBER_OF_DONE_TASKS = 0
        TOTAL_NUMBER_OF_TASKS = len(requests.get(TODOS_URL).json())

        for i in requests.get(TODOS_URL).json():
            if i['completed'] is True:
                NUMBER_OF_DONE_TASKS += 1

        print(f"Employee {EMPLOYEE_NAME} is done with "
              f"tasks({NUMBER_OF_DONE_TASKS}/{TOTAL_NUMBER_OF_TASKS}):")

        for i in requests.get(TODOS_URL).json():
            if i['completed'] is True:
                print("\t " + i['title'])
    except e as Exception:
        pass
