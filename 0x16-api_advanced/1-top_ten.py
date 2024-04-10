#!/usr/bin/python3
'''
A script that contains a function that queries the Reddit API and returns the
number of subscribers (not active users, total subscribers) for
a given subreddit.
'''
import requests


def top_ten(subreddit):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {'User-Agent': 'Custom User Agent'}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        data = response.json()
        posts = data['data']['children']
        if posts:
            for post in posts:
                print(post['data']['title'])
        else:
            print(str(None))
    else:
        print(str(None))
