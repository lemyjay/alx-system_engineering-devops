#!/usr/bin/python3
'''
A script that contains a function that queries the Reddit API and returns the
number of subscribers (not active users, total subscribers) for
a given subreddit.
'''
import requests
import requests.utils


def number_of_subscribers(subreddit):
    '''
    Returns the number of subcribers for a given valid subreddit or 0 if
    subreddit is invalid
    '''
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = requests.utils.default_headers()
    headers.update({'User-Agent': 'Custom User Agent'})
    response = requests.get(url, headers=headers, allow_redirects=False)


    data = response.json()
    if data['data']['subscribers']:
        return data['data']['subscribers']

    return 0
