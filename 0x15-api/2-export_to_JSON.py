#!/usr/bin/python3
'''
Python script that, using this REST API
`https://jsonplaceholder.typicode.com/todos/`, for a given employee ID,
returns information about his/her TODO list progress.
This script exports the data in JSON format.
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
        USERNAME = requests.get(USER_URL).json()["username"]
        TOTAL_NUMBER_OF_TASKS = len(requests.get(TODOS_URL).json())

        file_path = str(EMPLOYEE_ID) + '.json'
        with open(file_path, 'w') as file:
            task_list = '['
            for i in requests.get(TODOS_URL).json():
                TASK_COMPLETED_STATUS = str(i['completed']).lower()
                TASK_TITLE = i['title']
                task_info = '{' + f'"task": "{TASK_TITLE}", "completed": '
                task_info += f'{TASK_COMPLETED_STATUS}, "username": '
                task_info += f'"{USERNAME}"' + '}'
                task_list += task_info + ', '
            task_list = task_list[:-2]
            task_list += ']'
            file.write('{' + f'"{EMPLOYEE_ID}": {task_list}' + '}')

    except e as Exception:
        pass
