#!/usr/bin/python3
'''
Python script that, using this REST API
`https://jsonplaceholder.typicode.com/todos/`, for all employees,
returns information about his/her TODO list progress.
This script exports the data in JSON format.
'''
import requests

if __name__ == "__main__":

    try:
        BASE_URL = 'https://jsonplaceholder.typicode.com/'
        USERS = f"{BASE_URL}users/"
        ALL_USERS = requests.get(USERS).json()
        
        # USER_URL = f"{BASE_URL}users/{EMPLOYEE_ID}"
        # TODOS_URL = f"{BASE_URL}/todos?userId={EMPLOYEE_ID}"
        # EMPLOYEE_NAME = requests.get(USER_URL).json()["name"]
        # USERNAME = requests.get(USER_URL).json()["username"]
        # TOTAL_NUMBER_OF_TASKS = len(requests.get(TODOS_URL).json())

        # print(requests.get(USERS).json())
        # print(requests.get(USERS).text)
        # print(NUMBER_OF_USERS)
        
        file_path = 'todo_all_employees.json'
        
        final = '{'
        for i in ALL_USERS:
            current_user_id = int(i['id'])
            TODOS_URL = f"{BASE_URL}/todos?userId={current_user_id}"
            USER_URL = f"{BASE_URL}users/{current_user_id}"
            USERNAME = requests.get(USER_URL).json()["username"]
            ALL_TODOS = requests.get(TODOS_URL).json()

            
            task_list = '['
            for j in ALL_TODOS:
                TASK_COMPLETED_STATUS = str(j['completed']).lower()
                TASK_TITLE = j['title']
                task_info = '{' + f'"username": "{USERNAME}", "task": "{TASK_TITLE}", "completed": {TASK_COMPLETED_STATUS}' + '}'
                task_list += task_info + ', '
            task_list = task_list[:-2]
            task_list += '], '
            final +=  f'"{current_user_id}": {task_list}'
        final = final[:-2]
        final += '}'
        with open(file_path, 'w') as file:
            file.write(final)

    except e as Exception:
        pass
