#!/usr/bin/python3
'''
A script that contains a function that queries the Reddit API and returns the
number of subscribers (not active users, total subscribers) for
a given subreddit.
'''
import requests


def count_words(subreddit, word_list, after=None, counts={}):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=100"
    headers = {'User-Agent': 'Custom User Agent'}
    params = {'after': after} if after else {}
    response = requests.get(url, headers=headers,
                            params=params, allow_redirects=False)

    if response.status_code == 200:
        data = response.json()
        posts = data['data']['children']
        if posts:
            for post in posts:
                title = post['data']['title'].lower()
                for word in word_list:
                    if title.count(word.lower()) > 0:
                        counts[word.lower()] = (
                            counts.get(word.lower(), 0) +
                            title.count(word.lower()))
            after = data['data']['after']
            if after:
                return count_words(subreddit, word_list, after, counts)
            else:
                sorted_counts = sorted(counts.items(),
                                       key=lambda x: (-x[1], x[0]))
                for word, count in sorted_counts:
                    print(f"{word}: {count}")
